-- ROBLOX upstream: https://github.com/graphql/graphql-js/blob/aa650618426a301e3f0f61ead3adcd755055a627/src/type/schema.js
local root = script.Parent.Parent
type Array<T> = { [number]: T }
type Set<T> = { [T]: boolean }
local Packages = root.Parent.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = require(root.luaUtils.Error)

local objectValues = require(root.polyfills.objectValues).objectValues
local jsutils = root.jsutils
local inspect = require(jsutils.inspect).inspect
local toObjMap = require(jsutils.toObjMap).toObjMap
local devAssert = require(jsutils.devAssert).devAssert
local instanceOf = require(jsutils.instanceOf)
local isObjectLike = require(jsutils.isObjectLike).isObjectLike

local introspection = require(script.Parent.introspection)
local __Schema = introspection.__Schema

local _ast = require(root.language.ast)
type SchemaDefinitionNode = _ast.SchemaDefinitionNode
type SchemaExtensionNode = _ast.SchemaExtensionNode

local _GraphQLError = require(root.error.GraphQLError)
type GraphQLError = _GraphQLError.GraphQLError

local directives = require(script.Parent.directives)
type GraphQLDirective = any -- directives.GraphQLDirective
local isDirective = directives.isDirective
local specifiedDirectives = directives.specifiedDirectives

local _ObjMapModule = require(jsutils.ObjMap)
type ObjMap<T> = _ObjMapModule.ObjMap<T>
type ObjMapLike<T> = _ObjMapModule.ObjMapLike<T>

local definition = require(script.Parent.definition)
type GraphQLType = any -- definition.GraphQLType
type GraphQLNamedType = any -- definition.GraphQLNamedType
type GraphQLAbstractType = any -- definition.GraphQLAbstractType
type GraphQLObjectType = any -- definition.GraphQLObjectType
type GraphQLInterfaceType = any -- definition.GraphQLInterfaceType

local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isInputObjectType = definition.isInputObjectType
local getNamedType = definition.getNamedType

-- ROBLOX deviation: pre-declare variables
local GraphQLSchema
local collectReferencedTypes

-- /**
--  * Test if the given value is a GraphQL schema.
--  */
local function isSchema(schema: any): boolean
	return instanceOf(schema, GraphQLSchema)
end

local function assertSchema(schema: any): GraphQLSchema
	if not isSchema(schema) then
		error(Error.new(("Expected %s to be a GraphQL schema."):format(inspect(schema))))
	end
	return schema
end

-- /**
--  * Schema Definition
--  *
--  * A Schema is created by supplying the root types of each type of operation,
--  * query and mutation (optional). A schema definition is then supplied to the
--  * validator and executor.
--  *
--  * Example:
--  *
--  *     const MyAppSchema = new GraphQLSchema({
--  *       query: MyAppQueryRootType,
--  *       mutation: MyAppMutationRootType,
--  *     })
--  *
--  * Note: When the schema is constructed, by default only the types that are
--  * reachable by traversing the root types are included, other types must be
--  * explicitly referenced.
--  *
--  * Example:
--  *
--  *     const characterInterface = new GraphQLInterfaceType({
--  *       name: 'Character',
--  *       ...
--  *     });
--  *
--  *     const humanType = new GraphQLObjectType({
--  *       name: 'Human',
--  *       interfaces: [characterInterface],
--  *       ...
--  *     });
--  *
--  *     const droidType = new GraphQLObjectType({
--  *       name: 'Droid',
--  *       interfaces: [characterInterface],
--  *       ...
--  *     });
--  *
--  *     const schema = new GraphQLSchema({
--  *       query: new GraphQLObjectType({
--  *         name: 'Query',
--  *         fields: {
--  *           hero: { type: characterInterface, ... },
--  *         }
--  *       }),
--  *       ...
--  *       // Since this schema references only the `Character` interface it's
--  *       // necessary to explicitly list the types that implement it if
--  *       // you want them to be included in the final schema.
--  *       types: [humanType, droidType],
--  *     })
--  *
--  * Note: If an array of `directives` are provided to GraphQLSchema, that will be
--  * the exact list of directives represented and allowed. If `directives` is not
--  * provided then a default set of the specified directives (e.g. @include and
--  * @skip) will be used. If you wish to provide *additional* directives to these
--  * specified directives, you must explicitly declare them. Example:
--  *
--  *     const MyAppSchema = new GraphQLSchema({
--  *       ...
--  *       directives: specifiedDirectives.concat([ myCustomDirective ]),
--  *     })
--  *
--  */
export type GraphQLSchema = {
	description: string?,
	extensions: ObjMap<any>?,
	astNode: SchemaDefinitionNode?,
	extensionASTNodes: Array<SchemaExtensionNode>?,

	_queryType: GraphQLObjectType?,
	_mutationType: GraphQLObjectType?,
	_subscriptionType: GraphQLObjectType?,
	_directives: Array<GraphQLDirective>,
	_typeMap: TypeMap,
	_subTypeMap: ObjMap<ObjMap<boolean>>,
	_implementationsMap: ObjMap<{
		objects: Array<GraphQLObjectType>,
		interfaces: Array<GraphQLInterfaceType>,
	}>,

	-- // Used as a cache for validateSchema().
	__validationErrors: Array<GraphQLError>?,
}

GraphQLSchema = {}
GraphQLSchema.__index = GraphQLSchema

function GraphQLSchema.new(config: GraphQLSchemaConfig): GraphQLSchema
	local self = setmetatable({}, GraphQLSchema)

	-- // If this schema was built from a source known to be valid, then it may be
	-- // marked with assumeValid to avoid an additional type system validation.
	self.__validationErrors = nil
	if config.assumeValid == true then
		self.__validationErrors = {}
	end

	-- // Check for common mistakes during construction to produce early errors.
	devAssert(isObjectLike(config), "Must provide configuration object.")
	devAssert(
		not config.types or Array.isArray(config.types),
		('"types" must be Array if provided but got: %s.'):format(inspect(config.types))
	)
	devAssert(
		not config.directives or Array.isArray(config.directives),
		'"directives" must be Array if provided but got: ' .. ('%s.'):format(
			inspect(config.directives)
		)
	)

	self.description = config.description
	self.extensions = config.extensions and toObjMap(config.extensions)
	self.astNode = config.astNode
	self.extensionASTNodes = config.extensionASTNodes

	self._queryType = config.query
	self._mutationType = config.mutation
	self._subscriptionType = config.subscription
	-- // Provide specified directives (e.g. @include and @skip) by default.
	self._directives = config.directives or specifiedDirectives

	-- // To preserve order of user-provided types, we add first to add them to
	-- // the set of "collected" types, so `collectReferencedTypes` ignore them.
	local allReferencedTypes: Set<GraphQLNamedType> = {}
	for _, type_ in ipairs(config.types or {}) do
		allReferencedTypes[type_] = true
	end
	if config.types ~= nil then
		for _, type_ in ipairs(config.types) do
			-- // When we ready to process this type, we remove it from "collected" types
			-- // and then add it together with all dependent types in the correct position.
			allReferencedTypes[type_] = nil
			collectReferencedTypes(type_, allReferencedTypes)
		end
	end

	if self._queryType ~= nil then
		collectReferencedTypes(self._queryType, allReferencedTypes)
	end
	if self._mutationType ~= nil then
		collectReferencedTypes(self._mutationType, allReferencedTypes)
	end
	if self._subscriptionType ~= nil then
		collectReferencedTypes(self._subscriptionType, allReferencedTypes)
	end

	for _, directive in ipairs(self._directives) do
		-- Directives are not validated until validateSchema() is called.
		if isDirective(directive) then
			for _, arg in ipairs(directive.args) do
				collectReferencedTypes(arg.type, allReferencedTypes)
			end
		end
	end
	collectReferencedTypes(__Schema, allReferencedTypes)

	-- // Storing the resulting map for reference by the schema.
	self._typeMap = {}
	self._subTypeMap = {}
	-- // Keep track of all implementations by interface name.
	self._implementationsMap = {}

	for namedType, _ in pairs(allReferencedTypes) do
		-- ROBLOX deviation: there is `nil` element in a Lua list
		-- if namedType == nil then
		-- 	continue
		-- end

		local typeName = namedType.name
		devAssert(
			typeName and typeName ~= "",
			"One of the provided types for building the Schema is missing a name."
		)
		if self._typeMap[typeName] ~= nil then
			error(Error.new(
				('Schema must contain uniquely named types but contains multiple types named "%s".')
					:format(typeName)
			))
		end
		self._typeMap[typeName] = namedType

		if isInterfaceType(namedType) then
			-- // Store implementations by interface.
			for _, iface in ipairs(namedType:getInterfaces()) do
				if isInterfaceType(iface) then
					local implementations = self._implementationsMap[iface.name]
					if implementations == nil then
						implementations = {
							objects = {},
							interfaces = {},
						}
						self._implementationsMap[iface.name] = implementations
					end

					table.insert(implementations.interfaces, namedType)
				end
			end
		elseif isObjectType(namedType) then
			-- // Store implementations by objects.
			for _, iface in ipairs(namedType:getInterfaces()) do
				if isInterfaceType(iface) then
					local implementations = self._implementationsMap[iface.name]

					if implementations == nil then
						implementations = {
							objects = {},
							interfaces = {},
						}
						self._implementationsMap[iface.name] = implementations
					end

					table.insert(implementations.objects, namedType)
				end
			end
		end
	end

	return self
end

function GraphQLSchema:getQueryType(): GraphQLObjectType?
	return self._queryType
end

function GraphQLSchema:getMutationType(): GraphQLObjectType?
	return self._mutationType
end

function GraphQLSchema:getSubscriptionType(): GraphQLObjectType?
	return self._subscriptionType
end

function GraphQLSchema:getTypeMap(): TypeMap
	return self._typeMap
end

function GraphQLSchema:getType(name): GraphQLNamedType?
	return self:getTypeMap()[name]
end

function GraphQLSchema:getPossibleTypes(
	abstractType: GraphQLAbstractType
): Array<GraphQLObjectType>
	if isUnionType(abstractType) then
		return abstractType:getTypes()
	else
		return self:getImplementations(abstractType).objects
	end
end

function GraphQLSchema:getImplementations(
	interfaceType: GraphQLInterfaceType
): {
	objects: Array<GraphQLObjectType>,
	interfaces: Array<GraphQLInterfaceType>,
}
	local implementations = self._implementationsMap[interfaceType.name]
	return implementations or { objects = {}, interfaces = {} }
end

function GraphQLSchema:isSubType(
	abstractType: GraphQLAbstractType,
	maybeSubType: GraphQLObjectType | GraphQLInterfaceType
): boolean
	local map = self._subTypeMap[abstractType.name]
	if map == nil then
		map = {}

		if isUnionType(abstractType) then
			for _, type_ in ipairs(abstractType:getTypes()) do
				map[type_.name] = true
			end
		else
			local implementations = self:getImplementations(abstractType)
			for _, type_ in ipairs(implementations.objects) do
				map[type_.name] = true
			end
			for _, type_ in ipairs(implementations.interfaces) do
				map[type_.name] = true
			end
		end

		self._subTypeMap[abstractType.name] = map
	end

	return map[maybeSubType.name] ~= nil
end

function GraphQLSchema:getDirectives(): Array<GraphQLDirective>
	return self._directives
end

function GraphQLSchema:getDirective(name): GraphQLDirective?
	return Array.find(self:getDirectives(), function(directive)
		return directive.name == name
	end)
end

function GraphQLSchema:toConfig(): GraphQLSchemaNormalizedConfig
	return {
		description = self.description,
		query = self:getQueryType(),
		mutation = self:getMutationType(),
		subscription = self:getSubscriptionType(),
		types = objectValues(self:getTypeMap()),
		directives = Array.slice(self:getDirectives()),
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {},
		assumeValid = self.__validationErrors ~= nil,
	}
end

function GraphQLSchema:__tostring()
	return "GraphQLSchema"
end

type TypeMap = ObjMap<GraphQLNamedType>

export type GraphQLSchemaValidationOptions = {
	-- /**
	-- * When building a schema from a GraphQL service's introspection result, it
	-- * might be safe to assume the schema is valid. Set to true to assume the
	-- * produced schema is valid.
	-- *
	-- * Default: false
	-- */
	assumeValid: boolean?,
}

export type GraphQLSchemaConfig = {
	description: string?,
	query: GraphQLObjectType?,
	mutation: GraphQLObjectType?,
	subscription: GraphQLObjectType?,
	types: Array<GraphQLNamedType>?,
	directives: Array<GraphQLDirective>?,
	extensions: ObjMapLike<any>?,
	astNode: SchemaDefinitionNode?,
	extensionASTNodes: Array<SchemaExtensionNode>?,
	-- ...GraphQLSchemaValidationOptions,
} & GraphQLSchemaValidationOptions

-- /**
--  * @internal
--  */
export type GraphQLSchemaNormalizedConfig = GraphQLSchemaConfig & {
	-- ...GraphQLSchemaConfig,
	description: string?,
	types: Array<GraphQLNamedType>,
	directives: Array<GraphQLDirective>,
	extensions: ObjMap<any>?,
	extensionASTNodes: Array<SchemaExtensionNode>,
	assumeValid: boolean,
}

function collectReferencedTypes(
	type_: GraphQLType,
	typeSet: Set<GraphQLNamedType>
)
	local namedType = getNamedType(type_)

	if not typeSet[namedType] then
		typeSet[namedType] = true
		if isUnionType(namedType) then
			for _, memberType in ipairs(namedType:getTypes()) do
				collectReferencedTypes(memberType, typeSet)
			end
		elseif isObjectType(namedType) or isInterfaceType(namedType) then
			for _, interfaceType in ipairs(namedType:getInterfaces()) do
				collectReferencedTypes(interfaceType, typeSet)
			end

			for _, field in ipairs(objectValues(namedType:getFields())) do
				collectReferencedTypes(field.type, typeSet)
				for _, arg in ipairs(field.args) do
					collectReferencedTypes(arg.type, typeSet)
				end
			end
		elseif isInputObjectType(namedType) then
			for _, field in ipairs(objectValues(namedType:getFields())) do
				collectReferencedTypes(field.type, typeSet)
			end
		end
	end

	return typeSet
end

return {
	isSchema = isSchema,
	assertSchema = assertSchema,
	GraphQLSchema = GraphQLSchema,
}
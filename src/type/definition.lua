-- upstream: https://github.com/graphql/graphql-js/blob/00d4efea7f5b44088356798afff0317880605f4d/src/type/definition.js
-- Luau currently requires manual hoisting of types, which causes this file to become extremely unaligned
-- file checks out okay other than that issue, which looks like "definition.lua:149:5-15: (E001) Generic type 'GraphQLList' expects 0 type arguments, but 1 is specified"
-- Luau issue: https://jira.rbx.com/browse/CLI-34658

type Array<T> = { [number]: T }
local srcWorkspace = script.Parent.Parent
local Error = require(srcWorkspace.luaUtils.Error)
local LuauPolyfillImport = require(srcWorkspace.Parent.Packages.LuauPolyfill)
local PromiseModule = require(srcWorkspace.luaUtils.Promise)
type Promise<T> = PromiseModule.Promise<T>
local NULL = require(srcWorkspace.luaUtils.null)
local Array = LuauPolyfillImport.Array
local Object = LuauPolyfillImport.Object
local NaN_KEY = Object.freeze({})
local luaUtilsWorkspace = srcWorkspace.luaUtils
-- ROBLOX deviation: use ordered Map
local keyValMapOrdered = require(luaUtilsWorkspace.keyValMapOrdered).keyValMapOrdered
-- ROBLOX deviation: no distinction between undefined and null in Lua so we need to go around this with custom NULL like constant
local isNillish = require(luaUtilsWorkspace.isNillish).isNillish

-- ROBLOX deviation: use map type
local MapModule = require(srcWorkspace.luaUtils.Map)
local Map = MapModule.Map
local coerceToMap = MapModule.coerceToMap
type Map<T,V> = MapModule.Map<T,V>

local jsutilsWorkspace = srcWorkspace.jsutils
local ObjMap = require(jsutilsWorkspace.ObjMap)
type ObjMap<T> = ObjMap.ObjMap<T>
type ReadOnlyObjMap<T> = ObjMap.ReadOnlyObjMap<T>
type ReadOnlyObjMapLike<T> = ObjMap.ReadOnlyObjMapLike<T>
local inspect = require(jsutilsWorkspace.inspect).inspect
local keyMap = require(jsutilsWorkspace.keyMap).keyMap
local toObjMap = require(jsutilsWorkspace.toObjMap).toObjMap
local devAssert = require(jsutilsWorkspace.devAssert).devAssert
local instanceOf = require(jsutilsWorkspace.instanceOf)
local didYouMean = require(jsutilsWorkspace.didYouMean).didYouMean
local isObjectLike = require(jsutilsWorkspace.isObjectLike).isObjectLike
local identityFunc = require(jsutilsWorkspace.identityFunc).identityFunc
local suggestionList = require(jsutilsWorkspace.suggestionList).suggestionList
local PromiseOrValueModule = require(jsutilsWorkspace.PromiseOrValue)
type PromiseOrValue<T> = PromiseOrValueModule.PromiseOrValue<T>

-- ROBLOX deviation: use map value ordered
local mapValueOrdered = require(srcWorkspace.luaUtils.mapValueOrdered).mapValueOrdered

local GraphQLError = require(srcWorkspace.error.GraphQLError).GraphQLError

local languageWorkspace = srcWorkspace.language
local Kind = require(languageWorkspace.kinds).Kind
local print_ = require(languageWorkspace.printer).print

local Ast = require(srcWorkspace.language.ast)
type ScalarTypeDefinitionNode = Ast.ScalarTypeDefinitionNode
type ObjectTypeDefinitionNode = Ast.ObjectTypeDefinitionNode
type FieldDefinitionNode = Ast.FieldDefinitionNode
type InputValueDefinitionNode = Ast.InputValueDefinitionNode
type InterfaceTypeDefinitionNode = Ast.InterfaceTypeDefinitionNode
type UnionTypeDefinitionNode = Ast.UnionTypeDefinitionNode
type EnumTypeDefinitionNode = Ast.EnumTypeDefinitionNode
type EnumValueDefinitionNode = Ast.EnumValueDefinitionNode
type InputObjectTypeDefinitionNode = Ast.InputObjectTypeDefinitionNode
type ScalarTypeExtensionNode = Ast.ScalarTypeExtensionNode
type ObjectTypeExtensionNode = Ast.ObjectTypeExtensionNode
type InterfaceTypeExtensionNode = Ast.InterfaceTypeExtensionNode
type UnionTypeExtensionNode = Ast.UnionTypeExtensionNode
type EnumTypeExtensionNode = Ast.EnumTypeExtensionNode
type InputObjectTypeExtensionNode = Ast.InputObjectTypeExtensionNode
type OperationDefinitionNode = Ast.OperationDefinitionNode
type FieldNode = Ast.FieldNode
type FragmentDefinitionNode = Ast.FragmentDefinitionNode
type ValueNode = Ast.ValueNode

local valueFromASTUntyped = require(srcWorkspace.utilities.valueFromASTUntyped).valueFromASTUntyped

-- ROBLOX deviation: this results in a circular dependency, so we fudge the type here
-- local schemaModule = require(script.Parent.schema)
-- type GraphQLSchema = schemaModule.GraphQLSchema
type GraphQLSchema = any

-- ROBLOX deviation: predeclare functions
local isType
local assertType
local isScalarType
local assertScalarType
local isObjectType
local assertObjectType
local isInterfaceType
local assertInterfaceType
local isUnionType
local assertUnionType
local isEnumType
local assertEnumType
local isInputObjectType
local assertInputObjectType
local isListType
local assertListType
local isNonNullType
local assertNonNullType
local isInputType
local assertInputType
local isOutputType
local assertOutputType
local isLeafType
local assertLeafType
local isCompositeType
local assertCompositeType
local isAbstractType
local assertAbstractType
local isWrappingType
local assertWrappingType
local isNullableType
local assertNullableType
local getNullableType
local isNamedType
local assertNamedType
local getNamedType
local argsToArgsConfig
local isRequiredArgument
local isRequiredInputField
local defineInputFieldMap
local defineTypes
local isPlainObj
local didYouMeanEnumValue
local defineEnumValues
local fieldsToFieldsConfig
local defineInterfaces
local defineFieldMap

-- ROBLOX deviation: predeclare classes
local GraphQLList
local GraphQLNonNull
local GraphQLScalarType
local GraphQLObjectType
local GraphQLInterfaceType
local GraphQLUnionType
local GraphQLEnumType
local GraphQLInputObjectType

-- Predicates & Assertions

--[[*
 * These are all of the possible kinds of types.
 *]]
export type GraphQLType =
  GraphQLScalarType
  | GraphQLObjectType
  | GraphQLInterfaceType
  | GraphQLUnionType
  | GraphQLEnumType
  | GraphQLInputObjectType
  | GraphQLList<any>
  | GraphQLNonNull<any>

function isType(type_: any): boolean
	return isScalarType(type_) or isObjectType(type_) or isInterfaceType(type_) or isUnionType(type_) or isEnumType(type_) or isInputObjectType(type_) or isListType(type_) or isNonNullType(type_)
end

function assertType(type_: any): GraphQLType
	if not isType(type_) then
		error(Error.new(("Expected %s to be a GraphQL type."):format(inspect(type_))))
	end

	return type_
end

--[[*
--  * There are predicates for each kind of GraphQL type.
--  *]]

function isScalarType(type_: any): boolean
	return instanceOf(type_, GraphQLScalarType)
end

function assertScalarType(type_: any): GraphQLScalarType
	if not isScalarType(type_) then
		error(Error.new(("Expected %s to be a GraphQL Scalar type."):format(inspect(type_))))
	end

	return type_
end

function isObjectType(type_: any): boolean
	return instanceOf(type_, GraphQLObjectType)
end

function assertObjectType(type_: any): GraphQLObjectType
	if not isObjectType(type_) then
		error(Error.new(("Expected %s to be a GraphQL Object type."):format(inspect(type_))))
	end

	return type_
end

function isInterfaceType(type_: any): boolean
	return instanceOf(type_, GraphQLInterfaceType)
end

function assertInterfaceType(type_: any): GraphQLInterfaceType
	if not isInterfaceType(type_) then
		error(Error.new(("Expected %s to be a GraphQL Interface type."):format(inspect(type_))))
	end

	return type_
end

function isUnionType(type_: any): boolean
	return instanceOf(type_, GraphQLUnionType)
end

function assertUnionType(type_: any): GraphQLUnionType
	if not isUnionType(type_) then
		error(Error.new(("Expected %s to be a GraphQL Union type."):format(inspect(type_))))
	end

	return type_
end

function isEnumType(type_): boolean
	return instanceOf(type_, GraphQLEnumType)
end

function assertEnumType(type_): GraphQLEnumType
	if not isEnumType(type_) then
		error(Error.new(("Expected %s to be a GraphQL Enum type."):format(inspect(type_))))
	end

	return type_
end

function isInputObjectType(type_): boolean
	return instanceOf(type_, GraphQLInputObjectType)
end

function assertInputObjectType(type_): GraphQLInputObjectType
	if not isInputObjectType(type_) then
		error(Error.new(("Expected %s to be a GraphQL Input Object type."):format(inspect(type_))))
	end

	return type_
end

function isListType(type_): boolean
	return instanceOf(type_, GraphQLList)
end

function assertListType(type_): GraphQLList<any>
	if not isListType(type_) then
		error(Error.new(("Expected %s to be a GraphQL List type."):format(inspect(type_))))
	end

	return type_
end

function isNonNullType(type_): boolean
	return instanceOf(type_, GraphQLNonNull)
end

function assertNonNullType(type_): GraphQLNonNull<any>
	if not isNonNullType(type_) then
		error(Error.new(("Expected %s to be a GraphQL Non-Null type."):format(inspect(type_))))
	end

	return type_
end

--[[*
 * These types may be used as input types for arguments and directives.
 ]]
export type GraphQLInputType =
  GraphQLScalarType
  | GraphQLEnumType
  | GraphQLInputObjectType
  | GraphQLList<GraphQLInputType>
  | GraphQLNonNull<
      GraphQLScalarType
      | GraphQLEnumType
      | GraphQLInputObjectType
      | GraphQLList<GraphQLInputType>
    >

function isInputType(type_)
	return isScalarType(type_) or isEnumType(type_) or isInputObjectType(type_) or isWrappingType(type_) and isInputType(type_.ofType)
end

function assertInputType(type_)
	if not isInputType(type_) then
		error(Error.new(("Expected %s to be a GraphQL input type."):format(inspect(type_))))
	end

	return type_
end

--[[*
 * These types may be used as output types as the result of fields.
 ]]
export type GraphQLOutputType =
  GraphQLScalarType
  | GraphQLObjectType
  | GraphQLInterfaceType
  | GraphQLUnionType
  | GraphQLEnumType
  | GraphQLList<GraphQLOutputType>
  | GraphQLNonNull<
      GraphQLScalarType
      | GraphQLObjectType
      | GraphQLInterfaceType
      | GraphQLUnionType
      | GraphQLEnumType
      | GraphQLList<GraphQLOutputType>
    >


function isOutputType(type_): boolean
	return isScalarType(type_) or isObjectType(type_) or isInterfaceType(type_) or isUnionType(type_) or isEnumType(type_) or isWrappingType(type_) and isOutputType(type_.ofType)
end

function assertOutputType(type_): GraphQLOutputType
	if not isOutputType(type_) then
		error(Error.new(("Expected %s to be a GraphQL output type."):format(inspect(type_))))
	end

	return type_
end

--[[*
 * These types may describe types which may be leaf values.
 ]]
export type GraphQLLeafType = GraphQLScalarType | GraphQLEnumType

function isLeafType(type_): boolean
	return isScalarType(type_) or isEnumType(type_)
end

function assertLeafType(type_): GraphQLLeafType
	if not isLeafType(type_) then
		error(Error.new(("Expected %s to be a GraphQL leaf type."):format(inspect(type_))))
	end

	return type_
end

--[[*
 * These types may describe the parent context of a selection set.
 ]]
export type GraphQLCompositeType =
  GraphQLObjectType
  | GraphQLInterfaceType
  | GraphQLUnionType

function isCompositeType(type_): boolean
	return isObjectType(type_) or isInterfaceType(type_) or isUnionType(type_)
end

function assertCompositeType(type_): GraphQLCompositeType
	if not isCompositeType(type_) then
		error(Error.new(("Expected %s to be a GraphQL composite type."):format(inspect(type_))))
	end

	return type_
end

--[[*
 * These types may describe the parent context of a selection set.
 ]]
export type GraphQLAbstractType = GraphQLInterfaceType | GraphQLUnionType

function isAbstractType(type_): boolean
	return isInterfaceType(type_) or isUnionType(type_)
end

function assertAbstractType(type_): GraphQLAbstractType
	if not isAbstractType(type_) then
		error(Error.new(("Expected %s to be a GraphQL abstract type."):format(inspect(type_))))
	end

	return type_
end

-- /**
--  * List Type Wrapper
--  *
--  * A list is a wrapping type which points to another type.
--  * Lists are often created within the context of defining the fields of
--  * an object type.
--  *
--  * Example:
--  *
--  *     const PersonType = new GraphQLObjectType({
--  *       name: 'Person',
--  *       fields: () => ({
--  *         parents: { type: new GraphQLList(PersonType) },
--  *         children: { type: new GraphQLList(PersonType) },
--  *       })
--  *     })
--  *
--  */
export type GraphQLList<T> = {
	ofType: T
}

GraphQLList = {}

GraphQLList.__index = GraphQLList

function GraphQLList.new(ofType)
	local self = {}

	devAssert(
		isType(ofType),
		("Expected %s to be a GraphQL type."):format(inspect(ofType))
	)

	self.ofType = ofType

	return setmetatable(self, GraphQLList)
end

function GraphQLList.__tostring(self)
	return self:toString()
end

function GraphQLList.toString(self)
	return "[" .. tostring(self.ofType) .. "]"
end

function GraphQLList.toJSON(self)
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLList';
--   }
-- }

-- /**
--  * Non-Null Type Wrapper
--  *
--  * A non-null is a wrapping type which points to another type.
--  * Non-null types enforce that their values are never null and can ensure
--  * an error is raised if this ever occurs during a request. It is useful for
--  * fields which you can make a strong guarantee on non-nullability, for example
--  * usually the id field of a database row will never be null.
--  *
--  * Example:
--  *
--  *     const RowType = new GraphQLObjectType({
--  *       name: 'Row',
--  *       fields: () => ({
--  *         id: { type: new GraphQLNonNull(GraphQLString) },
--  *       })
--  *     })
--  *
--  * Note: the enforcement of non-nullability occurs within the executor.
--  */
export type GraphQLNonNull<T> = {
	ofType: T
}

GraphQLNonNull = {}

GraphQLNonNull.__index = GraphQLNonNull

function GraphQLNonNull.new(ofType)
	local self = {}
	devAssert(
		isNullableType(ofType),
		("Expected %s to be a GraphQL nullable type."):format(inspect(ofType))
	)

	self.ofType = ofType
	return setmetatable(self, GraphQLNonNull)
end

function GraphQLNonNull.__tostring(self)
	return self:toString()
end

function GraphQLNonNull.toString(self)
	return tostring(self.ofType) .. "!"
end

function GraphQLNonNull.toJSON(self)
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLNonNull';
--   }
-- }

--[[*
 * These types wrap and modify other types
 ]]

export type GraphQLWrappingType = GraphQLList<any> | GraphQLNonNull<any>

function isWrappingType(type_): boolean
	return isListType(type_) or isNonNullType(type_)
end

function assertWrappingType(type_): GraphQLWrappingType
	if not isWrappingType(type_) then
		error(Error.new(("Expected %s to be a GraphQL wrapping type."):format(inspect(type_))))
	end

	return type_
end

--[[*
 * These types can all accept null as a value.
 ]]
export type GraphQLNullableType =
  GraphQLScalarType
  | GraphQLObjectType
  | GraphQLInterfaceType
  | GraphQLUnionType
  | GraphQLEnumType
  | GraphQLInputObjectType
  | GraphQLList<any>

function isNullableType(type_): boolean
	return isType(type_) and not isNonNullType(type_)
end

function assertNullableType(type_): GraphQLNullableType
	if not isNullableType(type_) then
		error(Error.new(("Expected %s to be a GraphQL nullable type."):format(inspect(type_))))
	end

	return type_
end

function getNullableType(type_)
	if type_ then
		return (function()
			if isNonNullType(type_) then
				return type_.ofType
			end

			return type_
		end)()
	end

	-- ROBLOX deviation: upstream JS implicitly returns undefined
	return nil
end

--[[*
 * These named types do not include modifiers like List or NonNull.
 ]]
export type GraphQLNamedType =
  GraphQLScalarType
  | GraphQLObjectType
  | GraphQLInterfaceType
  | GraphQLUnionType
  | GraphQLEnumType
  | GraphQLInputObjectType

function isNamedType(type_): boolean
	return isScalarType(type_) or isObjectType(type_) or isInterfaceType(type_) or isUnionType(type_) or isEnumType(type_) or isInputObjectType(type_)
end

function assertNamedType(type_): GraphQLNamedType
	if not isNamedType(type_) then
		error(Error.new(("Expected %s to be a GraphQL named type."):format(inspect(type_))))
	end

	return type_
end

function getNamedType(type_)
	if type_ then
		local unwrappedType = type_

		while isWrappingType(unwrappedType) do
			unwrappedType = unwrappedType.ofType
		end

		return unwrappedType
	end

	-- ROBLOX deviation: upstream JS implicitly returns undefined
	return nil
end

--[[*
 * Used while defining GraphQL types to allow for circular references in
 * otherwise immutable type definitions.
 ]]
export type Thunk<T> = (() -> T) | T

-- ROBLOX TODO: align once Luau has function generics
local function resolveThunk(thunk: Thunk<any>)
	return (function() -- ROBLOX TODO: IFEE not necessary
		if typeof(thunk) == "function" then
			-- ROBLOX TODO: workaround for Luau type narrowing bug
			local _thunk: any = thunk
			return _thunk()
		end

		return thunk
	end)()
end

local function undefineIfEmpty(arr: Array<any>?): Array<any>?
	return (function() -- ROBLOX TODO: IFEE not necessary
			-- ROBLOX TODO: workaround for Luau type narrowing bug
			local _arr: any = arr
		if _arr and #_arr > 0 then
			return _arr
		end

		return nil
	end)()
end

--[[*
--  * Scalar Type Definition
--  *
--  * The leaf values of any request and input values to arguments are
--  * Scalars (or Enums) and are defined with a name and a series of functions
--  * used to parse input from ast or variables and to ensure validity.
--  *
--  * If a type's serialize function does not return a value (i.e. it returns
--  * `undefined`) then an error will be raised and a `null` value will be returned
--  * in the response. If the serialize function returns `null`, then no error will
--  * be included in the response.
--  *
--  * Example:
--  *
--  *     const OddType = new GraphQLScalarType({
--  *       name: 'Odd',
--  *       serialize(value) {
--  *         if (value % 2 === 1) {
--  *           return value;
--  *         }
--  *       }
--  *     });
--  *
--  *]]
export type GraphQLScalarType = {
	name: string,
	description: string?,
	specifiedByUrl: string?,
	serialize: GraphQLScalarSerializer<any>,
	parseValue: GraphQLScalarValueParser<any>,
	parseLiteral: GraphQLScalarLiteralParser<any>,
	extensions: ReadOnlyObjMap<any>?,
	astNode: ScalarTypeDefinitionNode?,
	extensionASTNodes: Array<ScalarTypeExtensionNode>?,

	-- ROBLOX deviation: add extra parameter for self
	toConfig: (any) -> GraphQLScalarTypeNormalizedConfig,
	toString: (any) -> string,
	toJSON: (any) -> string
}

GraphQLScalarType = {}

GraphQLScalarType.__index = GraphQLScalarType

function GraphQLScalarType.new(config: GraphQLScalarTypeConfig<any, any>)
	local self = {}
	local parseValue
	if config.parseValue then
		parseValue = config.parseValue
	else
		parseValue = identityFunc
	end
	self.name = config.name
	self.description = config.description
	self.specifiedByUrl = config.specifiedByUrl
	-- ROBLOX devation: we need to wrap the actual function to handle the `self` param correctly
	local serialize = (function()
		local _ref = config.serialize

		if _ref == nil then
			_ref = identityFunc
		end
		return _ref
	end)()
	self.serialize = function(_, ...)
		return serialize(...)
	end
	-- ROBLOX devation: we need to wrap the actual function to handle the `self` param correctly
	self.parseValue = function(_, ...)
		return parseValue(...)
	end
	-- ROBLOX devation: we need to wrap the actual function to handle the `self` param correctly
	local parseLiteral = (function()
		local _ref = config.parseLiteral

		if _ref == nil then
			_ref = function(node, variables)
				return parseValue(valueFromASTUntyped(node, variables))
			end
		end
		return _ref
	end)()
	self.parseLiteral = function(_, ...)
		return parseLiteral(...)
	end
	self.extensions = config.extensions and toObjMap(config.extensions)
	self.astNode = config.astNode
	self.extensionASTNodes = undefineIfEmpty(config.extensionASTNodes)

	devAssert(typeof(config.name) == "string", "Must provide name.")

	devAssert(
		isNillish(config.specifiedByUrl) or typeof(config.specifiedByUrl) == "string",
		("%s must provide \"specifiedByUrl\" as a string, "):format(self.name) .. ("but got: %s."):format(inspect(config.specifiedByUrl))
	)

	devAssert(
		config.serialize == nil or typeof(config.serialize) == "function",
		("%s must provide \"serialize\" function. If this custom Scalar is also used as an input type, ensure \"parseValue\" and \"parseLiteral\" functions are also provided."):format(self.name)
	)

	if config.parseLiteral then
		devAssert(
			typeof(config.parseValue) == "function" and typeof(config.parseLiteral) == "function",
			("%s must provide both \"parseValue\" and \"parseLiteral\" functions."):format(self.name)
		)
	end

	return setmetatable(self, GraphQLScalarType)
end

function GraphQLScalarType:toConfig(): GraphQLScalarTypeNormalizedConfig
	return {
		name = self.name,
		description = self.description,
		specifiedByUrl = self.specifiedByUrl,
		serialize = self.serialize,
		parseValue = self.parseValue,
		parseLiteral = self.parseLiteral,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = (function()
			local _ref = self.extensionASTNodes

			if _ref == nil then
				_ref = {}
			end
			return _ref
		end)(),
	}
end

function GraphQLScalarType.__tostring(self): string
	return self:toString()
end

function GraphQLScalarType:toString(): string
	return self.name
end

function GraphQLScalarType:toJSON(): string
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLScalarType';
--   }
-- }

export type GraphQLScalarSerializer<TExternal> = (
  any
) -> TExternal?

export type GraphQLScalarValueParser<TInternal> = (
  any
) -> TInternal?

export type GraphQLScalarLiteralParser<TInternal> = (
  ValueNode,
  ObjMap<any>?
) -> TInternal?

export type GraphQLScalarTypeConfig<TInternal, TExternal> = {
  name: string,
  description: string?,
  specifiedByUrl: string?,
  -- Serializes an internal value to include in a response.
  serialize: GraphQLScalarSerializer<TExternal>?,
  -- Parses an externally provided value to use as an input.
  parseValue: GraphQLScalarValueParser<TInternal>?,
  -- Parses an externally provided literal value to use as an input.
  parseLiteral: GraphQLScalarLiteralParser<TInternal>?,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: ScalarTypeDefinitionNode?,
  extensionASTNodes: Array<ScalarTypeExtensionNode>?,
}

type GraphQLScalarTypeNormalizedConfig = GraphQLScalarTypeConfig<any, any> & {
  serialize: GraphQLScalarSerializer<any>,
  parseValue: GraphQLScalarValueParser<any>,
  parseLiteral: GraphQLScalarLiteralParser<any>,
  extensions: ReadOnlyObjMap<any>?,
  extensionASTNodes: Array<ScalarTypeExtensionNode>,
}

--[[*
--  * Object Type Definition
--  *
--  * Almost all of the GraphQL types you define will be object types. Object types
--  * have a name, but most importantly describe their fields.
--  *
--  * Example:
--  *
--  *     const AddressType = new GraphQLObjectType({
--  *       name: 'Address',
--  *       fields: {
--  *         street: { type: GraphQLString },
--  *         number: { type: GraphQLInt },
--  *         formatted: {
--  *           type: GraphQLString,
--  *           resolve(obj) {
--  *             return obj.number + ' ' + obj.street
--  *           }
--  *         }
--  *       }
--  *     });
--  *
--  * When two types need to refer to each other, or a type needs to refer to
--  * itself in a field, you can use a function expression (aka a closure or a
--  * thunk) to supply the fields lazily.
--  *
--  * Example:
--  *
--  *     const PersonType = new GraphQLObjectType({
--  *       name: 'Person',
--  *       fields: () => ({
--  *         name: { type: GraphQLString },
--  *         bestFriend: { type: PersonType },
--  *       })
--  *     });
--  *
--  *]]
export type GraphQLObjectType = {
	name: string,
	description: string?,
	isTypeOf: GraphQLIsTypeOfFn<any, any>?,
	extensions: ReadOnlyObjMap<any>?,
	astNode: ObjectTypeDefinitionNode?,
	extensionASTNodes: Array<ObjectTypeExtensionNode>?,
	-- ROBLOX deviation: extra argument for self
	getFields: (any) -> GraphQLFieldMap<any, any>,
	getInterfaces: (any) -> Array<GraphQLInterfaceType>,
	toConfig: (any) -> GraphQLObjectTypeNormalizedConfig,
	toString: (any) -> string,
	toJSON: (any) -> string
}

GraphQLObjectType = {}
GraphQLObjectType.__index = GraphQLObjectType

function GraphQLObjectType.new(config: GraphQLObjectTypeConfig<any, any>)
	local self = {}
	self.name = config.name
	self.description = config.description
	self.isTypeOf = config.isTypeOf
	self.extensions = config.extensions and toObjMap(config.extensions)
	self.astNode = config.astNode
	self.extensionASTNodes = undefineIfEmpty(config.extensionASTNodes)

	self._fields = function()
		return defineFieldMap(config)
	end
	self._interfaces = function()
		return defineInterfaces(config)
	end
	devAssert(typeof(config.name) == "string", "Must provide name.")
	devAssert(
		config.isTypeOf == nil or typeof(config.isTypeOf) == "function",
		("%s must provide \"isTypeOf\" as a function, " .. "but got: %s."):format(self.name, inspect(config.isTypeOf))
	)

	return setmetatable(self, GraphQLObjectType)
end

function GraphQLObjectType:getFields(): GraphQLFieldMap<any, any>
	if typeof(self._fields) == "function" then
		self._fields = self._fields()
	end
	return self._fields
end

function GraphQLObjectType:getInterfaces(): Array<GraphQLInterfaceType>
	if typeof(self._interfaces) == "function" then
		self._interfaces = self._interfaces()
	end
	return self._interfaces
end

function GraphQLObjectType:toConfig(): GraphQLObjectTypeNormalizedConfig
	return {
		name = self.name,
		description = self.description,
		interfaces = self:getInterfaces(),
		fields = fieldsToFieldsConfig(self:getFields()),
		isTypeOf = self.isTypeOf,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {},
	}
end

function GraphQLObjectType.__tostring(self): string
	return self:toString()
end

function GraphQLObjectType.toString(self): string
	return self.name
end

function GraphQLObjectType.toJSON(self): string
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLObjectType';
--   }
-- }

function defineInterfaces(
	config: GraphQLObjectTypeConfig<any, any>
    | GraphQLInterfaceTypeConfig<any, any>
): Array<GraphQLInterfaceType>
	local interfaces = (function()
		local _ref = resolveThunk(config.interfaces)

		if _ref == nil then
			_ref = {}
		end
		return _ref
	end)()

	devAssert(
		Array.isArray(interfaces),
		("%s interfaces must be an Array or a function which returns an Array."):format(config.name)
	)

	return interfaces
end

-- ROBLOX TODO: revisit when Luau function generics are implemented
-- function defineFieldMap<TSource, TContext>(
type TSource = any
type TContext = any

function defineFieldMap(
	config: GraphQLObjectTypeConfig<TSource, TContext>
    | GraphQLInterfaceTypeConfig<TSource, TContext>
): GraphQLFieldMap<TSource, TContext>
	local fieldMap_ = resolveThunk(config.fields)

	-- ROBLOX deviation: valueMap is either Map object or vanilla table
	devAssert(
		isPlainObj(fieldMap_) or instanceOf(fieldMap_, Map),
		("%s fields must be an object with field names as keys or a function which returns such an object."):format(config.name)
	)

	-- Roblox deviation: coerce to map
	local fieldMap = coerceToMap(fieldMap_)

	return mapValueOrdered(fieldMap, function(fieldConfig, fieldName)
		devAssert(
			isPlainObj(fieldConfig),
			("%s.%s field config must be an object."):format(config.name, fieldName)
		)
		devAssert(
			fieldConfig.resolve == nil or typeof(fieldConfig.resolve) == "function",
			("%s.%s field resolver must be a function if "):format(config.name, fieldName) ..
			("provided, but got: %s."):format(inspect(fieldConfig.resolve))
		)

		local argsConfig = (function()
			local _ref = fieldConfig.args

			if _ref == nil then
				_ref = {}
			end
			return _ref
		end)()

		devAssert(
			isPlainObj(argsConfig) or instanceOf(argsConfig, Map),
			("%s.%s args must be an object with argument names as keys."):format(config.name, fieldName)
		)

		local args = Array.map(coerceToMap(argsConfig):entries(), function(entries)
			local argName, argConfig = entries[1], entries[2]

			return {
				name = argName,
				description = argConfig.description,
				type = argConfig.type,
				defaultValue = argConfig.defaultValue,
				deprecationReason = argConfig.deprecationReason,
				extensions = argConfig.extensions and toObjMap(argConfig.extensions),
				astNode = argConfig.astNode,
			}
		end)

		return {
			name = fieldName,
			description = fieldConfig.description,
			type = fieldConfig.type,
			args = args,
			resolve = fieldConfig.resolve,
			subscribe = fieldConfig.subscribe,
			deprecationReason = fieldConfig.deprecationReason,
			extensions = fieldConfig.extensions and toObjMap(fieldConfig.extensions),
			astNode = fieldConfig.astNode,
		}
	end)
end

function isPlainObj(obj: any): boolean
	--[[
		ROBLOX deviation:
		* we need to exclude NULL specifically as it's represented as a regular table
		* empty object is treated as an Array but in this case we want to allow it
	]]
	return obj ~= NULL and isObjectLike(obj) and (not Array.isArray(obj) or next(obj) == nil)
end

function fieldsToFieldsConfig(
	fields: GraphQLFieldMap<any, any>
): GraphQLFieldConfigMap<any, any>
	-- ROBLOX deviation: use Map
	return mapValueOrdered(fields, function(field)
		return {
			description = field.description,
			type = field.type,
			args = argsToArgsConfig(field.args),
			resolve = field.resolve,
			subscribe = field.subscribe,
			deprecationReason = field.deprecationReason,
			extensions = field.extensions,
			astNode = field.astNode,
		}
	end)
end

--[[*
--  * @internal
--  *]]
function argsToArgsConfig(
	args: Array<GraphQLArgument>
): GraphQLFieldConfigArgumentMap
	return keyValMapOrdered(args, function(arg)
		return arg.name
	end, function(arg)
		return {
			description = arg.description,
			type = arg.type,
			defaultValue = arg.defaultValue,
			deprecationReason = arg.deprecationReason,
			extensions = arg.extensions,
			astNode = arg.astNode,
		}
	end)
end

export type GraphQLObjectTypeConfig<TSource, TContext> = {
  name: string,
  description: string?,
  interfaces: Thunk<Array<GraphQLInterfaceType>?>?,
  fields: Thunk<GraphQLFieldConfigMap<TSource, TContext>>,
  isTypeOf: GraphQLIsTypeOfFn<TSource, TContext>?,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: ObjectTypeDefinitionNode?,
  extensionASTNodes: Array<ObjectTypeExtensionNode>?,
}

type GraphQLObjectTypeNormalizedConfig = GraphQLObjectTypeConfig<any, any> & {
  interfaces: Array<GraphQLInterfaceType>,
  fields: GraphQLFieldConfigMap<any, any>,
  extensions: ReadOnlyObjMap<any>?,
  extensionASTNodes: Array<ObjectTypeExtensionNode>,
}

--[[*
 * Note: returning GraphQLObjectType is deprecated and will be removed in v16.0.0
 ]]
export type GraphQLTypeResolver<TSource, TContext> = (
  TSource,
  TContext,
  GraphQLResolveInfo,
  GraphQLAbstractType
) -> PromiseOrValue<string | nil>

export type GraphQLIsTypeOfFn<TSource, TContext> = (
  TSource,
  TContext,
  GraphQLResolveInfo
) -> PromiseOrValue<boolean>

-- ROBLOX devation: we can't default type arguments. TArgs defaults to the same thing everywhere in this file:
type DefaultTArgs = { [string]: any }

export type GraphQLFieldResolver<
  TSource,
  TContext,
  TArgs -- ROBLOX deviation: Luau can't express default for type params, so we workaround with DefaultTArgs
> = (
  TSource,
  TArgs,
  TContext,
  GraphQLResolveInfo
) -> any

export type GraphQLResolveInfo = {
  fieldName: string,
  fieldNodes: Array<FieldNode>,
  returnType: GraphQLOutputType,
  parentType: GraphQLObjectType,
  path: Path,
  schema: GraphQLSchema,
  fragments: ObjMap<FragmentDefinitionNode>,
  rootValue: any,
  operation: OperationDefinitionNode,
  variableValues: { [string]: any }
}

export type GraphQLFieldConfig<
  TSource,
  TContext,
  TArgs -- ROBLOX deviation: Luau can't express default type arg assignments, so we workaround with DefaultTArgs
> = {
  description: string?,
  type: GraphQLOutputType,
  args: GraphQLFieldConfigArgumentMap?,
  resolve: GraphQLFieldResolver<TSource, TContext, any>?,
  subscribe: GraphQLFieldResolver<TSource, TContext, TArgs>?,
  deprecationReason: string?,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: FieldDefinitionNode?,
}

export type GraphQLFieldConfigArgumentMap = ObjMap<GraphQLArgumentConfig>

export type GraphQLArgumentConfig = {
  description: string?,
  type: GraphQLInputType,
  defaultValue: any?,
  extensions: ReadOnlyObjMapLike<any>?,
  deprecationReason: string?,
  astNode: InputValueDefinitionNode?,
}

export type GraphQLFieldConfigMap<TSource, TContext> = ObjMap<
-- ROBLOX deviation: use Default TArgs at declaration, since Luau doesn't support defaulting type args
  GraphQLFieldConfig<TSource, TContext, DefaultTArgs>
>

export type GraphQLField<
  TSource,
  TContext,
  TArgs -- ROBLOX deviation: Luau can't express default type arg assignments, so we workaround with DefaultTArgs
> = {
  name: string,
  description: string?,
  type: GraphQLOutputType,
  args: Array<GraphQLArgument>,
  resolve: GraphQLFieldResolver<TSource, TContext, TArgs>?,
  subscribe: GraphQLFieldResolver<TSource, TContext, TArgs>?,
  deprecationReason: string?,
  extensions: ReadOnlyObjMap<any>?,
  astNode: FieldDefinitionNode?,
}

export type GraphQLArgument = {
  name: string,
  description: string?,
  type: GraphQLInputType,
  defaultValue: any,
  deprecationReason: string?,
  extensions: ReadOnlyObjMap<any>?,
  astNode: InputValueDefinitionNode?,
}


function isRequiredArgument(arg: GraphQLArgument): boolean
	return isNonNullType(arg.type) and arg.defaultValue == nil
end

export type GraphQLFieldMap<TSource, TContext> = ObjMap<
-- ROBLOX deviation: use Default TArgs at declaration, since Luau doesn't support defaulting type args
  GraphQLField<TSource, TContext, DefaultTArgs>
>

-- /**
--  * Interface Type Definition
--  *
--  * When a field can return one of a heterogeneous set of types, a Interface type
--  * is used to describe what types are possible, what fields are in common across
--  * all types, as well as a function to determine which type is actually used
--  * when the field is resolved.
--  *
--  * Example:
--  *
--  *     const EntityType = new GraphQLInterfaceType({
--  *       name: 'Entity',
--  *       fields: {
--  *         name: { type: GraphQLString }
--  *       }
--  *     });
--  *
--  */
export type GraphQLInterfaceType = {
	name: string,
	description: string?,
	resolveType: GraphQLTypeResolver<any, any>?,
	extensions: ReadOnlyObjMap<any>?,
	astNode: InterfaceTypeDefinitionNode?,
	extensionASTNodes: Array<InterfaceTypeExtensionNode>?,

	_fields: Thunk<GraphQLFieldMap<any, any>>,
	_interfaces: Thunk<Array<GraphQLInterfaceType>>,

	-- ROBLOX deviation: extra argument for self
	getFields: (any) -> GraphQLFieldMap<any, any>,
	getInterfaces: (any) -> Array<GraphQLInterfaceType>,
	toConfig: (any) -> GraphQLInterfaceTypeNormalizedConfig,
	toString: (any) -> string,
	toJSON: (any) -> string

}

GraphQLInterfaceType = {}
GraphQLInterfaceType.__index = GraphQLInterfaceType

function GraphQLInterfaceType.new(config: GraphQLInterfaceTypeConfig<any, any>)
	local self = {}
	self.name = config.name
	self.description = config.description
	self.resolveType = config.resolveType
	self.extensions = config.extensions and toObjMap(config.extensions)
	self.astNode = config.astNode
	self.extensionASTNodes = undefineIfEmpty(config.extensionASTNodes)

	self._fields = function()
		return defineFieldMap(config)
	end
	self._interfaces = function()
		return defineInterfaces(config)
	end
	devAssert(typeof(config.name) == "string", "Must provide name.")
	devAssert(
		config.resolveType == nil or typeof(config.resolveType) == "function",
		("%s must provide \"resolveType\" as a function, " .. "but got: %s."):format(self.name, inspect(config.resolveType))
	)

	return setmetatable(self, GraphQLInterfaceType)
end

function GraphQLInterfaceType:getFields(): GraphQLFieldMap<any, any>
	if typeof(self._fields) == "function" then
		self._fields = self._fields()
	end
	return self._fields
end

function GraphQLInterfaceType:getInterfaces(): Array<GraphQLInterfaceType>
	if typeof(self._interfaces) == "function" then
		self._interfaces = self._interfaces()
	end
	return self._interfaces
end

function GraphQLInterfaceType:toConfig(): GraphQLInterfaceTypeNormalizedConfig
	return {
		name = self.name,
		description = self.description,
		interfaces = self:getInterfaces(),
		fields = fieldsToFieldsConfig(self:getFields()),
		resolveType = self.resolveType,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {},
	}
end

function GraphQLInterfaceType.__tostring(self): string
	return self:toString()
end

function GraphQLInterfaceType.toString(self): string
	return self.name
end

function GraphQLInterfaceType.toJSON(self): string
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLInterfaceType';
--   }
-- }

export type GraphQLInterfaceTypeConfig<TSource, TContext> = {
  name: string,
  description: string?,
  interfaces: Thunk<Array<GraphQLInterfaceType>?>?,
  fields: Thunk<GraphQLFieldConfigMap<TSource, TContext>>,
  --[[*
   * Optionally provide a custom type resolver function. If one is not provided,
   * the default implementation will call `isTypeOf` on each implementing
   * Object type.
  ]]
  resolveType: GraphQLTypeResolver<TSource, TContext>?,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: InterfaceTypeDefinitionNode?,
  extensionASTNodes: Array<InterfaceTypeExtensionNode>?,
}

export type GraphQLInterfaceTypeNormalizedConfig = GraphQLInterfaceTypeConfig<any, any> & {
  interfaces: Array<GraphQLInterfaceType>,
  fields: GraphQLFieldConfigMap<any, any>,
  extensions: ReadOnlyObjMap<any>?,
  extensionASTNodes: Array<InterfaceTypeExtensionNode>,
}

-- /**
--  * Union Type Definition
--  *
--  * When a field can return one of a heterogeneous set of types, a Union type
--  * is used to describe what types are possible as well as providing a function
--  * to determine which type is actually used when the field is resolved.
--  *
--  * Example:
--  *
--  *     const PetType = new GraphQLUnionType({
--  *       name: 'Pet',
--  *       types: [ DogType, CatType ],
--  *       resolveType(value) {
--  *         if (value instanceof Dog) {
--  *           return DogType;
--  *         }
--  *         if (value instanceof Cat) {
--  *           return CatType;
--  *         }
--  *       }
--  *     });
--  *
--  */
export type GraphQLUnionType = {
	name: string,
	description: string?,
	resolveType: GraphQLTypeResolver<any, any>?,
	extensions: ReadOnlyObjMap<any>?,
	astNode: UnionTypeDefinitionNode?,
	extensionASTNodes: Array<UnionTypeExtensionNode>?,

	_types: Thunk<Array<GraphQLObjectType>>,
}

GraphQLUnionType = {}
GraphQLUnionType.__index = GraphQLUnionType

function GraphQLUnionType.new(config: GraphQLUnionTypeConfig<any, any>)
	local self = {}
	self.name = config.name
	self.description = config.description
	self.resolveType = config.resolveType
	self.extensions = config.extensions and toObjMap(config.extensions)
	self.astNode = config.astNode
	self.extensionASTNodes = undefineIfEmpty(config.extensionASTNodes)

	self._types = function()
		return defineTypes(config)
	end
	devAssert(typeof(config.name) == "string", "Must provide name.")
	devAssert(
		config.resolveType == nil or typeof(config.resolveType) == "function",
		("%s must provide \"resolveType\" as a function, " .. "but got: %s."):format(self.name, inspect(config.resolveType))
	)

	return setmetatable(self, GraphQLUnionType)
end

function GraphQLUnionType:getTypes(): Array<GraphQLObjectType>
	if typeof(self._types) == "function" then
		self._types = self._types()
	end
	return self._types
end

function GraphQLUnionType:toConfig(): GraphQLUnionTypeNormalizedConfig
	return {
		name = self.name,
		description = self.description,
		types = self:getTypes(),
		resolveType = self.resolveType,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {},
	}
end

function GraphQLUnionType.__tostring(self): string
	return self:toString()
end

function GraphQLUnionType.toString(self): string
	return self.name
end

function GraphQLUnionType.toJSON(self): string
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLUnionType';
--   }
-- }

function defineTypes(
	config: GraphQLUnionTypeConfig<any, any>
): Array<GraphQLObjectType>

	local types = resolveThunk(config.types)

	devAssert(
		Array.isArray(types),
		("Must provide Array of types or a function which returns such an array for Union %s."):format(config.name)
	)

	return types
end

export type GraphQLUnionTypeConfig<TSource, TContext> = {
  name: string,
  description: string?,
  types: Thunk<Array<GraphQLObjectType>>,
  --[[*
   * Optionally provide a custom type resolver function. If one is not provided,
   * the default implementation will call `isTypeOf` on each implementing
   * Object type.
   ]]
  resolveType: GraphQLTypeResolver<TSource, TContext>?,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: UnionTypeDefinitionNode?,
  extensionASTNodes: Array<UnionTypeExtensionNode>?,
}

type GraphQLUnionTypeNormalizedConfig = GraphQLUnionTypeConfig<any, any> & {
  types: Array<GraphQLObjectType>,
  extensions: ReadOnlyObjMap<any>?,
  extensionASTNodes: Array<UnionTypeExtensionNode>
}

-- /**
--  * Enum Type Definition
--  *
--  * Some leaf values of requests and input values are Enums. GraphQL serializes
--  * Enum values as strings, however internally Enums can be represented by any
--  * kind of type, often integers.
--  *
--  * Example:
--  *
--  *     const RGBType = new GraphQLEnumType({
--  *       name: 'RGB',
--  *       values: {
--  *         RED: { value: 0 },
--  *         GREEN: { value: 1 },
--  *         BLUE: { value: 2 }
--  *       }
--  *     });
--  *
--  * Note: If a value is not provided in a definition, the name of the enum value
--  * will be used as its internal value.
--  */
export type GraphQLEnumType = --[[ <T> ]] {
	name: string,
	description: string?,
	extensions: ReadOnlyObjMap<any>?,
	astNode: EnumTypeDefinitionNode?,
	extensionASTNodes: Array<EnumTypeExtensionNode>?,

	_values: Array<GraphQLEnumValue --[[ <T> ]]>,
	_valueLookup: Map<any --[[ T ]], GraphQLEnumValue>,
	_nameLookup: ObjMap<GraphQLEnumValue>,
	-- ROBLOX deviation: add self parameter for all ':' operator methods
	getValues: (any) -> Array<GraphQLEnumValue --[[ <T> ]]>,
	getValue: (any, string) -> GraphQLEnumValue?,
	serialize: (any, any --[[ T ]]) -> string?,
	parseValue: (any, any) -> any? --[[ T ]],
	parseLiteral: (any, ValueNode, ObjMap<any>?) -> any? --[[ T ]],
	-- ROBLOX deviation: we add a parameter here to account for self
	toConfig: (any) -> GraphQLEnumTypeNormalizedConfig
}

GraphQLEnumType = {}
GraphQLEnumType.__index = GraphQLEnumType

function GraphQLEnumType.new(config: GraphQLEnumTypeConfig)
	local self = {}
	self.name = config.name
	self.description = config.description
	self.extensions = config.extensions and toObjMap(config.extensions)
	self.astNode = config.astNode
	self.extensionASTNodes = undefineIfEmpty(config.extensionASTNodes)

	self._values = defineEnumValues(self.name, config.values)
	self._valueLookup = {}
	Array.map(self._values, function(enumValue)
		--[[
			ROBLOX deviation: we can't use NaN as a key
			we're using it's property that it's the only value that returns false when compared to itself
			NaN ~= NaN
		--]]
		if enumValue.value == enumValue.value then
			self._valueLookup[enumValue.value] = enumValue
		else
			self._valueLookup[NaN_KEY] = enumValue
		end
	end)
	self._nameLookup = keyMap(self._values, function(value)
		return value.name
	end)

	devAssert(typeof(config.name) == "string", "Must provide name.")

	return setmetatable(self, GraphQLEnumType)
end

function GraphQLEnumType:getValues(): Array<GraphQLEnumValue>
	return self._values
end

function GraphQLEnumType:getValue(name: string): GraphQLEnumValue?
	return self._nameLookup[name]
end

function GraphQLEnumType:serialize(outputValue: any): string?
	local enumValue
	--[[
		ROBLOX deviation: we can't use NaN as a key
		we're using it's property that it's the only value that returns false when compared to itself
		NaN ~= NaN
	--]]
	if outputValue == outputValue then
		enumValue = self._valueLookup[outputValue]
	else
		enumValue = self._valueLookup[NaN_KEY]
	end
	if enumValue == nil then
		error(GraphQLError.new(("Enum \"%s\" cannot represent value: %s"):format(self.name, inspect(outputValue))))
	end
	return enumValue.name
end

function GraphQLEnumType:parseValue(inputValue: any): any?
	if typeof(inputValue) ~= "string" then
		local valueStr = inspect(inputValue)
		error(GraphQLError.new(("Enum \"%s\" cannot represent non-string value: %s." .. didYouMeanEnumValue(self, valueStr)):format(self.name, valueStr)))
	end

	local enumValue = self:getValue(inputValue)
	if enumValue == nil then
		error(GraphQLError.new(("Value \"%s\" does not exist in \"%s\" enum."):format(inputValue, self.name) .. didYouMeanEnumValue(self, inputValue)))
	end
	return enumValue.value
end

function GraphQLEnumType:parseLiteral(valueNode: ValueNode, _variables: ObjMap<any>?): any?
	-- Note: variables will be resolved to a value before calling this function.
	if valueNode.kind ~= Kind.ENUM then
		local valueStr = print_(valueNode)
		error(GraphQLError.new(
			("Enum \"%s\" cannot represent non-enum value: %s."):format(self.name, valueStr) .. didYouMeanEnumValue(self, valueStr),
			valueNode
		))
	end

	local enumValue = self:getValue(valueNode.value)
	if enumValue == nil then
		local valueStr = print_(valueNode)
		error(GraphQLError.new(
			("Value \"%s\" does not exist in \"%s\" enum."):format(valueStr, self.name) .. didYouMeanEnumValue(self, valueStr),
			valueNode
		))
	end
	return enumValue.value
end

function GraphQLEnumType:toConfig(): GraphQLEnumTypeNormalizedConfig
	-- ROBLOX deviation: use ordered Map
	local values = keyValMapOrdered(self:getValues(), function(value)
		return value.name
	end, function(value)
		return {
			description = value.description,
			value = value.value,
			deprecationReason = value.deprecationReason,
			extensions = value.extensions,
			astNode = value.astNode,
		}
	end)

	return {
		name = self.name,
		description = self.description,
		values = values,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = (function()
			local _ref = self.extensionASTNodes

			if _ref == nil then
				_ref = {}
			end
			return _ref
		end)(),
	}
end

function GraphQLEnumType.__tostring(self): string
	return self:toString()
end

function GraphQLEnumType.toString(self): string
	return self.name
end

function GraphQLEnumType.toJSON(self): string
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLEnumType';
--   }
-- }

function didYouMeanEnumValue(
	enumType: GraphQLEnumType,
	unknownValueStr: string
): string
	local allNames = Array.map(enumType:getValues(), function(value)
		return value.name
	end)
	local suggestedValues = suggestionList(unknownValueStr, allNames)

	return didYouMean("the enum value", suggestedValues)
end

-- ROBLOX deviation: valueMap is either Map object or vanilla table
function defineEnumValues(
	typeName: string,
	valueMap: GraphQLEnumValueConfigMap
): Array<GraphQLEnumValue>
	devAssert(
		isPlainObj(valueMap) or instanceOf(valueMap, Map),
		("%s values must be an object with value names as keys."):format(tostring(typeName))
	)
	-- ROBLOX deviation: use Map if available
	local mapEntries = coerceToMap(valueMap):entries()

	return Array.map(mapEntries, function(entries)
		local valueName, valueConfig = entries[1], entries[2]

		devAssert(
			isPlainObj(valueConfig),
			("%s.%s must refer to an object with a \"value\" key "):format(
				tostring(typeName),
				tostring(valueName)
			) ..
			("representing an internal value but got: %s."):format(inspect(valueConfig))
		)

		return {
			-- ROBLOX deviation: in the case where an enum key is a boolean, JS somehow coerces it into a string
			name = tostring(valueName),
			description = valueConfig.description,
			value = (function()
				if valueConfig.value ~= nil then
					return valueConfig.value
				end

				return valueName
			end)(),
			deprecationReason = valueConfig.deprecationReason,
			extensions = valueConfig.extensions and toObjMap(valueConfig.extensions),
			astNode = valueConfig.astNode,
		}
	end)
end

export type GraphQLEnumTypeConfig --[[ <T> ]] = {
  name: string,
  description: string?,
  values: GraphQLEnumValueConfigMap --[[ <T> ]],
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: EnumTypeDefinitionNode?,
  extensionASTNodes: Array<EnumTypeExtensionNode>?,
}

type GraphQLEnumTypeNormalizedConfig = GraphQLEnumTypeConfig & {
  extensions: ReadOnlyObjMap<any>?,
  extensionASTNodes: Array<EnumTypeExtensionNode>,
}

export type GraphQLEnumValueConfigMap --[[ <T> ]] = ObjMap<GraphQLEnumValueConfig --[[ <T> ]]>

export type GraphQLEnumValueConfig --[[ <T> ]] = {
  description: string?,
  value: any --[[ T ]],
  deprecationReason: string?,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: EnumValueDefinitionNode?,
}

export type GraphQLEnumValue --[[ <T> ]] = {
  name: string,
  description: string?,
  value: any --[[ T ]],
  deprecationReason: string?,
  extensions: ReadOnlyObjMap<any>?,
  astNode: EnumValueDefinitionNode?,
}

-- /**
--  * Input Object Type Definition
--  *
--  * An input object defines a structured collection of fields which may be
--  * supplied to a field argument.
--  *
--  * Using `NonNull` will ensure that a value must be provided by the query
--  *
--  * Example:
--  *
--  *     const GeoPoint = new GraphQLInputObjectType({
--  *       name: 'GeoPoint',
--  *       fields: {
--  *         lat: { type: new GraphQLNonNull(GraphQLFloat) },
--  *         lon: { type: new GraphQLNonNull(GraphQLFloat) },
--  *         alt: { type: GraphQLFloat, defaultValue: 0 },
--  *       }
--  *     });
--  *
--  */
export type GraphQLInputObjectType = {
	name: string,
	description: string?,
	extensions: ReadOnlyObjMap<any>?,
	astNode: InputObjectTypeDefinitionNode?,
	extensionASTNodes: Array<InputObjectTypeExtensionNode>?,

	_fields: Thunk<GraphQLInputFieldMap>,

	-- ROBLOX deviation: extra argument for self
	getFields: (any) -> GraphQLInputFieldMap,
	getInterfaces: (any) -> Array<GraphQLInterfaceType>,
	toConfig: (any) -> GraphQLInputObjectTypeNormalizedConfig,
	toString: (any) -> string,
	toJSON: (any) -> string
}

GraphQLInputObjectType = {}
GraphQLInputObjectType.__index = GraphQLInputObjectType

function GraphQLInputObjectType.new(config: GraphQLInputObjectTypeConfig)
	local self = {}
	self.name = config.name
	self.description = config.description
	self.extensions = config.extensions and toObjMap(config.extensions)
	self.astNode = config.astNode
	self.extensionASTNodes = undefineIfEmpty(config.extensionASTNodes)

	self._fields = function()
		return defineInputFieldMap(config)
	end
	devAssert(typeof(config.name) == "string", "Must provide name.")
	return setmetatable(self, GraphQLInputObjectType)
end

function GraphQLInputObjectType:getFields(): GraphQLInputFieldMap
	if typeof(self._fields) == "function" then
		self._fields = self._fields()
	end
	return self._fields
end

function GraphQLInputObjectType:toConfig(): GraphQLInputObjectTypeNormalizedConfig
	-- ROBLOX deviation: use Map
	local fields = mapValueOrdered(self:getFields(), function(field)
		return {
			description = field.description,
			type = field.type,
			defaultValue = field.defaultValue,
			extensions = field.extensions,
			astNode = field.astNode,
		}
	end)

	return {
		name = self.name,
		description = self.description,
		fields = fields,
		extensions = self.extensions,
		astNode = self.astNode,
		extensionASTNodes = self.extensionASTNodes or {},
	}
end

function GraphQLInputObjectType.__tostring(self): string
	return self:toString()
end

function GraphQLInputObjectType.toString(self): string
	return self.name
end

function GraphQLInputObjectType.toJSON(self): string
	return self:toString()
end

-- ROBLOX deviation: get [Symbol.toStringTag]() is not used within Lua
--   // $FlowFixMe[unsupported-syntax] Flow doesn't support computed properties yet
--   get [Symbol.toStringTag]() {
--     return 'GraphQLInputObjectType';
--   }
-- }

function defineInputFieldMap(
	config: GraphQLInputObjectTypeConfig
): GraphQLInputFieldMap
	local fieldMap_ = resolveThunk(config.fields)

	-- ROBLOX deviation: valueMap is either Map object or vanilla table
	devAssert(
		isPlainObj(fieldMap_) or instanceOf(fieldMap_, Map),
		("%s fields must be an object with field names as keys or a function which returns such an object."):format(config.name)
	)

	-- Roblox deviation: coerce to map
	local fieldMap = coerceToMap(fieldMap_)

	return mapValueOrdered(fieldMap, function(fieldConfig, fieldName)
		devAssert(
			fieldConfig.resolve == nil,
			("%s.%s field has a resolve property, but Input Types cannot define resolvers."):format(config.name, fieldName)
		)

		return {
			name = fieldName,
			description = fieldConfig.description,
			type = fieldConfig.type,
			defaultValue = fieldConfig.defaultValue,
			deprecationReason = fieldConfig.deprecationReason,
			extensions = fieldConfig.extensions and toObjMap(fieldConfig.extensions),
			astNode = fieldConfig.astNode,
		}
	end)
end

export type GraphQLInputObjectTypeConfig = {
  name: string,
  description: string?,
  fields: Thunk<GraphQLInputFieldConfigMap>,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: InputObjectTypeDefinitionNode?,
  extensionASTNodes: Array<InputObjectTypeExtensionNode>?,
}

type GraphQLInputObjectTypeNormalizedConfig = GraphQLInputObjectTypeConfig & {
  fields: GraphQLInputFieldConfigMap,
  extensions: ReadOnlyObjMap<any>?,
  extensionASTNodes: Array<InputObjectTypeExtensionNode>,
}

export type GraphQLInputFieldConfig = {
  description: string?,
  type: GraphQLInputType,
  defaultValue: any?,
  deprecationReason: string?,
  extensions: ReadOnlyObjMapLike<any>?,
  astNode: InputValueDefinitionNode?,
}

export type GraphQLInputFieldConfigMap = ObjMap<GraphQLInputFieldConfig>

export type GraphQLInputField = {
  name: string,
  description: string?,
  type: GraphQLInputType,
  defaultValue: any,
  deprecationReason: string?,
  extensions: ReadOnlyObjMap<any>?,
  astNode: InputValueDefinitionNode?,
}

function isRequiredInputField(
	field: GraphQLInputField
): boolean
	return isNonNullType(field.type) and field.defaultValue == nil
end

export type GraphQLInputFieldMap = ObjMap<GraphQLInputField>

-- TODO
local dummyClass = {}

function dummyClass.new()
	return {}
end

return {
	GraphQLList = GraphQLList,
	GraphQLNonNull = GraphQLNonNull,
	GraphQLScalarType = GraphQLScalarType,
	GraphQLObjectType = GraphQLObjectType,
	GraphQLInterfaceType = GraphQLInterfaceType,
	GraphQLUnionType = GraphQLUnionType,
	GraphQLEnumType = GraphQLEnumType,
	GraphQLInputObjectType = GraphQLInputObjectType,
	isType = isType,
	assertType = assertType,
	isScalarType = isScalarType,
	assertScalarType = assertScalarType,
	isObjectType = isObjectType,
	assertObjectType = assertObjectType,
	isInterfaceType = isInterfaceType,
	assertInterfaceType = assertInterfaceType,
	isUnionType = isUnionType,
	assertUnionType = assertUnionType,
	isEnumType = isEnumType,
	assertEnumType = assertEnumType,
	isInputObjectType = isInputObjectType,
	assertInputObjectType = assertInputObjectType,
	isListType = isListType,
	assertListType = assertListType,
	isNonNullType = isNonNullType,
	assertNonNullType = assertNonNullType,
	isInputType = isInputType,
	assertInputType = assertInputType,
	isOutputType = isOutputType,
	assertOutputType = assertOutputType,
	isLeafType = isLeafType,
	assertLeafType = assertLeafType,
	isCompositeType = isCompositeType,
	assertCompositeType = assertCompositeType,
	isAbstractType = isAbstractType,
	assertAbstractType = assertAbstractType,
	isWrappingType = isWrappingType,
	assertWrappingType = assertWrappingType,
	isNullableType = isNullableType,
	assertNullableType = assertNullableType,
	getNullableType = getNullableType,
	isNamedType = isNamedType,
	assertNamedType = assertNamedType,
	getNamedType = getNamedType,
	argsToArgsConfig = argsToArgsConfig,
	isRequiredArgument = isRequiredArgument,
	isRequiredInputField = isRequiredInputField,
	-- ROBLOX deviation: no distinction between undefined and null in Lua so we need to go around this with custom NULL like constant
	NULL = NULL,
}

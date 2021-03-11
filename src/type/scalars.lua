-- upstream: https://github.com/graphql/graphql-js/blob/00d4efea7f5b44088356798afff0317880605f4d/src/type/scalars.js

local function parseInt(value, base)
	return tonumber(value, base)
end
local function NumberisFinite(value)
	return typeof(value) == "number" and value ~= math.huge and value == value
end
local parseFloat = parseInt
local Workspace = script.Parent.Parent
local Packages = Workspace.Parent.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local inspect = require(script.Parent.Parent.jsutils.inspect).inspect
local isObjectLike = require(script.Parent.Parent.jsutils.isObjectLike).isObjectLike
local Kind = require(script.Parent.Parent.language.kinds).Kind
local print_ = require(script.Parent.Parent.language.printer).print
local GraphQLError = require(script.Parent.Parent.error.GraphQLError).GraphQLError

local DefinitionModule = require(script.Parent.definition)
-- ROBLOX TODO: fundamental Luau issue in definition's type decls, so we workaround here
-- type GraphQLNamedType = DefinitionModule.GraphQLNamedType
type GraphQLNamedType = any
local GraphQLScalarType = DefinitionModule.GraphQLScalarType

-- As per the GraphQL Spec, Integers are only treated as valid when a valid
-- 32-bit signed integer, providing the broadest support across platforms.
--
-- n.b. JavaScript's integers are safe between -(2^53 - 1) and 2^53 - 1 because
-- they are internally represented as IEEE 754 doubles.
local MAX_INT = 2147483647
local MIN_INT = -2147483648

-- ROBLOX deviation: predeclare functions
local serializeObject, serializeID, serializeFloat, serializeBoolean, serializeString, isSpecifiedScalarType

function serializeInt(outputValue): number
	local coercedValue = serializeObject(outputValue)

	if typeof(coercedValue) == "boolean" then
		return (function()
			if coercedValue then
				return 1
			end

			return 0
		end)()
	end

	local num = coercedValue

	if typeof(coercedValue) == "string" and coercedValue ~= "" then
		num = tonumber(coercedValue)
	end
	if typeof(num) ~= "number" or not Number.isInteger(num) then
		error(GraphQLError.new(("Int cannot represent non-integer value: %s"):format(inspect(coercedValue))))
	end
	if num > MAX_INT or num < MIN_INT then
		error(GraphQLError.new("Int cannot represent non 32-bit signed integer value: " .. inspect(coercedValue)))
	end

	return num
end
function coerceInt(inputValue)
	if typeof(inputValue) ~= "number" or not Number.isInteger(inputValue) then
		error(GraphQLError.new(("Int cannot represent non-integer value: %s"):format(inspect(inputValue))))
	end
	if inputValue > MAX_INT or inputValue < MIN_INT then
		error(GraphQLError.new(("Int cannot represent non 32-bit signed integer value: %s"):format(inputValue)))
	end

	return inputValue
end

local GraphQLInt = GraphQLScalarType.new({
	name = "Int",
	description = "The `Int` scalar type represents non-fractional signed whole numeric values. Int can represent values between -(2^31) and 2^31 - 1.",
	serialize = serializeInt,
	parseValue = coerceInt,
	parseLiteral = function(valueNode)
		if valueNode.kind ~= Kind.INT then
			error(GraphQLError.new(
				("Int cannot represent non-integer value: %s"):format(print_(valueNode)),
				valueNode
			))
		end

		local num = parseInt(valueNode.value, 10)

		if num > MAX_INT or num < MIN_INT then
			error(GraphQLError.new(
				("Int cannot represent non 32-bit signed integer value: %s"):format(valueNode.value),
				valueNode
			))
		end

		return num
	end,
})

function serializeFloat(outputValue)
	local coercedValue = serializeObject(outputValue)

	if typeof(coercedValue) == "boolean" then
		return (function()
			if coercedValue then
				return 1
			end

			return 0
		end)()
	end

	local num = coercedValue

	if typeof(coercedValue) == "string" and coercedValue ~= "" then
		num = tonumber(coercedValue)
	end
	if typeof(num) ~= "number" or not NumberisFinite(num) then
		error(GraphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect(coercedValue))))
	end

	return num
end
function coerceFloat(inputValue)
	if typeof(inputValue) ~= "number" or not NumberisFinite(inputValue) then
		error(GraphQLError.new(("Float cannot represent non numeric value: %s"):format(inspect(inputValue))))
	end

	return inputValue
end

local GraphQLFloat = GraphQLScalarType.new({
	name = "Float",
	description = "The `Float` scalar type represents signed double-precision fractional values as specified by [IEEE 754](https://en.wikipedia.org/wiki/IEEE_floating_point).",
	serialize = serializeFloat,
	parseValue = coerceFloat,
	parseLiteral = function(valueNode)
		if valueNode.kind ~= Kind.FLOAT and valueNode.kind ~= Kind.INT then
			error(GraphQLError.new(
				("Float cannot represent non numeric value: %s"):format(print_(valueNode)),
				valueNode
			))
		end

		return parseFloat(valueNode.value)
	end,
})

-- Support serializing objects with custom valueOf() or toJSON() functions -
-- a common way to represent a complex value which can be represented as
-- a string (ex: MongoDB id objects).
function serializeObject(outputValue)
	if isObjectLike(outputValue) then
		if typeof(outputValue.valueOf) == "function" then
			local valueOfResult = outputValue:valueOf()

			if not isObjectLike(valueOfResult) then
				return valueOfResult
			end
		end
		if typeof(outputValue.toJSON) == "function" then
			return outputValue:toJSON()
		end
	end

	return outputValue
end

function serializeString(outputValue): string
	local coercedValue = serializeObject(outputValue)

	-- Serialize string, boolean and number values to a string, but do not
	-- attempt to coerce object, function, symbol, or other types as strings.
	if typeof(coercedValue) == "string" then
		return coercedValue
	end
	if typeof(coercedValue) == "boolean" then
		return (function()
			if coercedValue then
				return "true"
			end

			return "false"
		end)()
	end
	if typeof(coercedValue) == "number" and NumberisFinite(coercedValue) then
		return tostring(coercedValue)
	end

	error(GraphQLError.new(("String cannot represent value: %s"):format(inspect(outputValue))))
end
function coerceString(inputValue): string
	if typeof(inputValue) ~= "string" then
		error(GraphQLError.new(("String cannot represent a non string value: %s"):format(inspect(inputValue))))
	end

	return inputValue
end

local GraphQLString = GraphQLScalarType.new({
	name = "String",
	description = "The `String` scalar type represents textual data, represented as UTF-8 character sequences. The String type is most often used by GraphQL to represent free-form human-readable text.",
	serialize = serializeString,
	parseValue = coerceString,
	parseLiteral = function(valueNode)
		if valueNode.kind ~= Kind.STRING then
			error(GraphQLError.new(
				("String cannot represent a non string value: %s"):format(print_(valueNode)),
				valueNode
			))
		end

		return valueNode.value
	end,
})

function serializeBoolean(outputValue): boolean
	local coercedValue = serializeObject(outputValue)

	if typeof(coercedValue) == "boolean" then
		return coercedValue
	end
	-- ROBLOX TODO: put this into the polyfills library
	if NumberisFinite(coercedValue) then
		return coercedValue ~= 0
	end

	error(GraphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(inspect(coercedValue))))
end

function coerceBoolean(inputValue): boolean
	if typeof(inputValue) ~= "boolean" then
		error(GraphQLError.new(("Boolean cannot represent a non boolean value: %s"):format(inspect(inputValue))))
	end

	return inputValue
end

local GraphQLBoolean = GraphQLScalarType.new({
	name = "Boolean",
	description = "The `Boolean` scalar type represents `true` or `false`.",
	serialize = serializeBoolean,
	parseValue = coerceBoolean,
	parseLiteral = function(valueNode)
		if valueNode.kind ~= Kind.BOOLEAN then
			error(GraphQLError.new(
				("Boolean cannot represent a non boolean value: %s"):format(print_(valueNode)),
				valueNode
			))
		end

		return valueNode.value
	end,
})

function serializeID(outputValue): string
	local coercedValue = serializeObject(outputValue)

	if typeof(coercedValue) == "string" then
		return coercedValue
	end
	if Number.isInteger(coercedValue) then
		return tostring(coercedValue)
	end

	error(GraphQLError.new(("ID cannot represent value: %s"):format(inspect(outputValue))))
end

function coerceID(inputValue): string
	if typeof(inputValue) == "string" then
		return inputValue
	end
	if typeof(inputValue) == "number" and Number.isInteger(inputValue) then
		return tostring(inputValue)
	end

	error(GraphQLError.new(("ID cannot represent value: %s"):format(inspect(inputValue))))
end

local GraphQLID = GraphQLScalarType.new({
	name = "ID",
	description = "The `ID` scalar type represents a unique identifier, often used to refetch an object or as key for a cache. The ID type appears in a JSON response as a String; however, it is not intended to be human-readable. When expected as an input type, any string (such as `\"4\"`) or integer (such as `4`) input value will be accepted as an ID.",
	serialize = serializeID,
	parseValue = coerceID,
	parseLiteral = function(valueNode)
		if valueNode.kind ~= Kind.STRING and valueNode.kind ~= Kind.INT then
			error(GraphQLError.new(
				"ID cannot represent a non-string and non-integer value: " .. print_(valueNode),
				valueNode
			))
		end

		return valueNode.value
	end,
})
local specifiedScalarTypes = Object.freeze({
	GraphQLString,
	GraphQLInt,
	GraphQLFloat,
	GraphQLBoolean,
	GraphQLID,
})

function isSpecifiedScalarType(type_: GraphQLNamedType): boolean
	return Array.some(specifiedScalarTypes, function(scalarType)
		local name = scalarType.name
		return type_.name == name
	end)
end

return {
	GraphQLInt = GraphQLInt,
	GraphQLFloat = GraphQLFloat,
	GraphQLString = GraphQLString,
	GraphQLBoolean = GraphQLBoolean,
	GraphQLID = GraphQLID,
	specifiedScalarTypes = specifiedScalarTypes,
	isSpecifiedScalarType = isSpecifiedScalarType,
}

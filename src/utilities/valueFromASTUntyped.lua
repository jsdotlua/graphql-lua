--[[
 * Copyright (c) GraphQL Contributors
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
]]
-- ROBLOX upstream: https://github.com/graphql/graphql-js/blob/00d4efea7f5b44088356798afff0317880605f4d/src/utilities/valueFromASTUntyped.js
-- ROBLOX deviation: bring in polyfills
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Array = LuauPolyfill.Array
local coerceToTable = LuauPolyfill.coerceToTable
type Array<T> = LuauPolyfill.Array<T>

local NULL = require("../luaUtils/null")

local ObjMapModule = require("../jsutils/ObjMap")
type ObjMap<T> = ObjMapModule.ObjMap<T>

local inspect = require("../jsutils/inspect").inspect
local invariant = require("../jsutils/invariant").invariant
local keyValMap = require("../jsutils/keyValMap").keyValMap

local Kind = require("../language/kinds").Kind
local astModule = require("../language/ast")
type ValueNode = astModule.ValueNode

--[[**
 * Produces a JavaScript value given a GraphQL Value AST.
 *
 * Unlike `valueFromAST()`, no type is provided. The resulting JavaScript value
 * will reflect the provided GraphQL value AST.
 *
 * | GraphQL Value        | JavaScript Value |
 * | -------------------- | ---------------- |
 * | Input Object         | Object           |
 * | List                 | Array            |
 * | Boolean              | Boolean          |
 * | String / Enum        | String           |
 * | Int / Float          | Number           |
 * | Null                 | null             |
 *
 *]]

local function valueFromASTUntyped(
	-- ROBLOX TODO: this looks like a type bug in upstream, where ValueNode doesn't always have a value/values/fields field
	valueNode: any, -- ValueNode
	variables: ObjMap<any> -- ROBLOX TODO: should be nilable
): any
	if valueNode.kind == Kind.NULL then
		return NULL
	elseif valueNode.kind == Kind.INT then
		return tonumber(valueNode.value, 10)
	elseif valueNode.kind == Kind.FLOAT then
		return tonumber(valueNode.value)
	elseif
		valueNode.kind == Kind.STRING
		or valueNode.kind == Kind.ENUM
		or valueNode.kind == Kind.BOOLEAN
	then
		return valueNode.value
	elseif valueNode.kind == Kind.LIST then
		return Array.map(valueNode.values, function(node)
			return valueFromASTUntyped(node, variables)
		end)
	elseif valueNode.kind == Kind.OBJECT then
		-- ROBLOX deviation START: keyValMap returns a Map, convert back to object
		return coerceToTable(keyValMap(valueNode.fields, function(field)
			return field.name.value
		end, function(field)
			return valueFromASTUntyped(field.value, variables)
		end))
	elseif valueNode.kind == Kind.VARIABLE then
		return variables and variables[valueNode.name.value]
	end

	-- istanbul ignore next (Not reachable. All possible value nodes have been considered)
	invariant(false, "Unexpected value node: " .. inspect(valueNode))
	-- ROBLOX deviation: should never reach here, but need to convince analyzer
	error("Unexpected value node: " .. inspect(valueNode))
end

return {
	valueFromASTUntyped = valueFromASTUntyped,
}

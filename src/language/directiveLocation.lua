--[[
 * Copyright (c) GraphQL Contributors
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
]]
-- ROBLOX upstream: https://github.com/graphql/graphql-js/blob/v15.5.1/src/language/directiveLocation.js
local Object = require("@pkg/@jsdotlua/luau-polyfill").Object

-- ROBLOX FIXME: APPFDN-2420 fix definition of Object.freeze to preserve inner type
local DirectiveLocation = (
	Object.freeze({
		-- Request Definitions
		QUERY = "QUERY",
		MUTATION = "MUTATION",
		SUBSCRIPTION = "SUBSCRIPTION",
		FIELD = "FIELD",
		FRAGMENT_DEFINITION = "FRAGMENT_DEFINITION",
		FRAGMENT_SPREAD = "FRAGMENT_SPREAD",
		INLINE_FRAGMENT = "INLINE_FRAGMENT",
		VARIABLE_DEFINITION = "VARIABLE_DEFINITION",
		-- Type System Definitions
		SCHEMA = "SCHEMA",
		SCALAR = "SCALAR",
		OBJECT = "OBJECT",
		FIELD_DEFINITION = "FIELD_DEFINITION",
		ARGUMENT_DEFINITION = "ARGUMENT_DEFINITION",
		INTERFACE = "INTERFACE",
		UNION = "UNION",
		ENUM = "ENUM",
		ENUM_VALUE = "ENUM_VALUE",
		INPUT_OBJECT = "INPUT_OBJECT",
		INPUT_FIELD_DEFINITION = "INPUT_FIELD_DEFINITION",
	}) :: any
) :: { [string]: string }

--[[
	ROBLOX FIXME: add types
	Upstream: export type DirectiveLocationEnum = $Values<typeof DirectiveLocation>;
]]
--[[
 * The enum type representing the directive location values.
 *]]
export type DirectiveLocationEnum = string

return {
	DirectiveLocation = DirectiveLocation,
}

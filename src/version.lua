-- upstream: https://github.com/graphql/graphql-js/blob/00d4efea7f5b44088356798afff0317880605f4d/src/version.js

local rootWorkspace = script.Parent
local Object = require(rootWorkspace.Parent.LuauPolyfill).Object

--[[
 * Note: This file is autogenerated using "resources/gen-version.js" script and
 * automatically updated by "npm version" command.
 *]]

--[[
 * A string containing the version of the GraphQL.js library
 *]]
local version = '15.4.0';

--[[
 * An object containing the components of the GraphQL.js version string
 *]]
 local versionInfo = Object.freeze({
  major = 15,
  minor = 4,
  patch = 0,
  preReleaseTag = "",
})

return {
	version = version,
	versionInfo = versionInfo
}

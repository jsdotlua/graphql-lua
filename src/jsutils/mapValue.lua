-- upstream: https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/jsutils/mapValue.js
--[[
 * Creates an object map with the same keys as `map` and values generated by
 * running each value of `map` thru `fn`.
 ]]
local ObjMapModule = require(script.Parent.ObjMap)
type ObjMap = ObjMapModule.ObjMap

return function(map: ObjMap<any>, fn: (value, key) -> any)
: ObjMap<any>	local result = {}
	for key, value in pairs(map) do
		result[key] = fn(value, key)
	end
	return result
end

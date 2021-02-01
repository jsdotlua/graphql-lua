-- upstream: https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/jsutils/mapValue.js
--[[
 * Creates an object map with the same keys as `map` and values generated by
 * running each value of `map` thru `fn`.
 ]]
local ObjMapModule = require(script.Parent.ObjMap)
type ObjMap<T> = ObjMapModule.ObjMap<T>

-- ROBLOX TODO: update Luau types once generics are enabled
-- export function mapValue<T, V>(
-- 	map: ObjMap<T>,
-- 	fn: (value: T, key: string) => V,
--   ): ObjMap<V> {

return function(
    map: ObjMap<any>, 
    fn: (any, string) -> any
): ObjMap<any>	
  local result = {}
	for key, value in pairs(map) do
		result[key] = fn(value, key)
	end
	return result
end

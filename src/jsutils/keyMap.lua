-- upstream: https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/jsutils/keyMap.js
local ObjMapModule = require(script.Parent.ObjMap)
type ObjMap = ObjMapModule.ObjMap

--[[
 * Creates a keyed JS object from an array, given a function to produce the keys
 * for each value in the array.
 *
 * This provides a convenient lookup for the array items if the key function
 * produces unique results.
 *
 *     const phoneBook = [
 *       { name: 'Jon', num: '555-1234' },
 *       { name: 'Jenny', num: '867-5309' }
 *     ]
 *
 *     // { Jon: { name: 'Jon', num: '555-1234' },
 *     //   Jenny: { name: 'Jenny', num: '867-5309' } }
 *     const entriesByName = keyMap(
 *       phoneBook,
 *       entry => entry.name
 *     )
 *
 *     // { name: 'Jenny', num: '857-6309' }
 *     const jennyEntry = entriesByName['Jenny']
 *
 ]]
local function keyMap(list: Array<any>, keyFn: (any) -> string): ObjMap<any>
	local map = {}
	for i = 1, #list do
		local item = list[i]
		map[keyFn(item)] = item
	end
	return map
end

return {
	keyMap = keyMap,
}

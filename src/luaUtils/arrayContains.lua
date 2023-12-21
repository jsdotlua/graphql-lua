local deepEqual = require("./deepEqual")
local deepContains = require("./deepContains")

return function(tbl, item, looseEquals)
	-- see if item exists in table
	for _, value in ipairs(tbl) do
		if looseEquals then
			if deepContains(value, item) then
				return true
			end
		else
			if deepEqual(value, item) then
				return true
			end
		end
	end

	return false
end

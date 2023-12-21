local NULL = require("./null")

local function isNillish(val: any): boolean
	return val == nil or val == NULL
end

local function isNotNillish(val: any): boolean
	return val ~= nil and val ~= NULL
end

return {
	isNillish = isNillish,
	isNotNillish = isNotNillish,
}

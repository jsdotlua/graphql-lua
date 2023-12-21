local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
type Promise<T> = LuauPolyfill.Promise<T>

local Promise = require("@pkg/@jsdotlua/promise")
local PromiseOrValueModule = require('../jsutils/PromiseOrValue')
type PromiseOrValue<T> = PromiseOrValueModule.PromiseOrValue<T>

local function coerceToPromise<T>(value: PromiseOrValue<T>): Promise<T>
	if Promise.is(value) then
		return value :: Promise<T>
	else
		return Promise.resolve(value) :: Promise<T>
	end
end

return {
	coerceToPromise = coerceToPromise,
}

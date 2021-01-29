-- upstream: https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/jsutils/isPromise.js
local jsutils = script.Parent
local graphql = jsutils.Parent
local Packages = graphql.Parent.Packages
local Promise = require(Packages.Promise)

--[[
 * Returns true if the value acts like a Promise, i.e. has a "then" function,
 * otherwise returns false.
 ]]
local function isPromise(value)
	-- deviation: use the function provided by the Promise library
	return Promise.is(value)
end

return {
	isPromise = isPromise
}

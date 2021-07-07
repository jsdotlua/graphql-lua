-- upstream: https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/error/GraphQLError.js
type Array<T> = { [number]: T }

-- ROBLOX deviation: preamble
local srcWorkspace = script.Parent.Parent
local languageWorkspace = srcWorkspace.language
local Array = require(srcWorkspace.Parent.LuauPolyfill).Array
local Error = require(srcWorkspace.luaUtils.Error)
-- ROBLOX TODO: hoist this into luau-polyfill
type Error = {
    name: string,
    message: string,
    stack: string?
}
local HttpService = game:GetService("HttpService")

local isObjectLike = require(srcWorkspace.jsutils.isObjectLike).isObjectLike

local _astModule = require(languageWorkspace.ast)
type ASTNode = _astModule.ASTNode
local _sourceModule = require(languageWorkspace.source)
type Source = _sourceModule.Source
local locationModule = require(languageWorkspace.location)
type SourceLocation = locationModule.SourceLocation
local getLocation = locationModule.getLocation
local printLocationModule = require(languageWorkspace.printLocation)
local printLocation = printLocationModule.printLocation
local printSourceLocation = printLocationModule.printSourceLocation

-- ROBLOX deviation: pre-declare functions
local printError

local GraphQLError = setmetatable({}, { __index = Error })
GraphQLError.__index = GraphQLError
GraphQLError.__tostring = function(self)
	return printError(self)
end

export type GraphQLError = {
	-- /**
	--  * A message describing the Error for debugging purposes.
	--  *
	--  * Enumerable, and appears in the result of JSON.stringify().
	--  *
	--  * Note: should be treated as readonly, despite invariant usage.
	--  */
	message: string,

	-- /**
	--  * An array of { line, column } locations within the source GraphQL document
	--  * which correspond to this error.
	--  *
	--  * Errors during validation often contain multiple locations, for example to
	--  * point out two things with the same name. Errors during execution include a
	--  * single location, the field which produced the error.
	--  *
	--  * Enumerable, and appears in the result of JSON.stringify().
	--  */
	locations: Array<SourceLocation>, -- ROBLOX TODO: Luau can't express void type, so use nil instead once it supports narrowing properly

	-- /**
	--  * An array describing the JSON-path into the execution response which
	--  * corresponds to this error. Only included for errors during execution.
	--  *
	--  * Enumerable, and appears in the result of JSON.stringify().
	--  */
	path: Array<string | number> | nil, -- ROBLOX deviation: Luau can't express void type, so use nil instead

	-- /**
	--  * An array of GraphQL AST Nodes corresponding to this error.
	--  */
	nodes: Array<ASTNode>, -- ROBLOX TODO: Luau can't express void type, so use nil instead once it supports narrowing properly

	-- /**
	--  * The source GraphQL document for the first location of this error.
	--  *
	--  * Note that if this Error represents more than one node, the source may not
	--  * represent nodes after the first node.
	--  */
	source: Source | nil, -- ROBLOX deviation: Luau can't express void type, so use nil instead

	-- /**
	--  * An array of character offsets within the source GraphQL document
	--  * which correspond to this error.
	--  */
	positions: Array<number> | nil, -- ROBLOX deviation: Luau can't express void type, so use nil instead

	-- /**
	--  * The original error thrown from a field resolver during execution.
	--  */
	originalError: Error?,

	-- /**
	--  * Extension fields to add to the formatted error.
	--  */
	extensions: { [string]: any }?, -- ROBLOX TODO: missing type varargs from upstream
}

function GraphQLError.new(
	message: string,
	nodes: any, -- ROBLOX deviation: Luau doesn't have `%checks` functionality Array<ASTNode> | ASTNode | nil,
	source: Source?,
	positions: Array<number>,
	path: Array<string | number>,
	-- ROBLOX TODO: missing type varargs from upstream
	-- ROBLOX TODO: missing nil-ability due to Luau narrowing bug
	originalError: (Error & { extensions: any? }),
	extensions: { [string]: any }? -- ROBLOX TODO: missing type varargs from upstream
): GraphQLError

	-- Compute list of blame nodes.
	local _nodes = nil
	if Array.isArray(nodes) then
		if #nodes ~= 0 then
			_nodes = nodes
		end
	elseif nodes ~= nil then
		_nodes = { nodes }
	end

	-- Compute locations in the source for the given nodes/positions.
	local _source = source
	if _source == nil and _nodes ~= nil then
		_source = _nodes[1].loc ~= nil and _nodes[1].loc.source or nil
	end

	local _positions = positions
	if _positions == nil and _nodes ~= nil then
		_positions = Array.reduce(_nodes, function(list, node)
			if node.loc ~= nil then
				table.insert(list, node.loc.start)
			end
			return list
		end, {})
	end
	if _positions ~= nil and #_positions == 0 then
		_positions = nil
	end

	local _locations
	if positions ~= nil and source ~= nil then
		_locations = Array.map(positions, function(pos)
			return getLocation(source, pos)
		end)
	elseif _nodes ~= nil then
		_locations = Array.reduce(_nodes, function(list, node)
			if node.loc ~= nil then
				table.insert(list, getLocation(node.loc.source, node.loc.start))
			end
			return list
		end, {})
	end

	local _extensions = extensions
	if _extensions == nil and originalError ~= nil then
		local originalExtensions = originalError.extensions
		if isObjectLike(originalExtensions) then
			_extensions = originalExtensions
		end
	end

	local self = Error.new(message)
	self.name = "GraphQLError"
	self.locations = _locations
	self.path = path
	self.nodes = _nodes
	self.source = _source
	self.positions = _positions
	self.originalError = originalError
	self.extensions = _extensions

	if (originalError and originalError.stack) ~= nil then
		self.stack = originalError.stack
	end

	-- if Error.captureStackTrace ~= nil then
	-- 	Error.captureStackTrace(self, GraphQLError)
	-- else
	-- 	self.stack = Error.new().stack
	-- end

	-- FIXME: workaround to not break chai comparisons, should be remove in v16
	-- ROBLOX deviation: remove already deprecated API only used for JS tests

	return setmetatable(self, GraphQLError)
end

function GraphQLError:toString(): string
	return printError(self)
end

-- ROBLOX deviation: in JS JSON.stringify prints only enumerable props and Lua doesn't support that. This is fallback
function GraphQLError:toJSON(): string
	local enumerableProps = {
		"message",
		self.locations ~= nil and "locations" or nil,
		self.path ~= nil and "path" or nil,
		self.extensions ~= nil and "extensions" or nil,
	}

	return HttpService:JSONEncode(Array.reduce(enumerableProps, function(obj, prop)
		obj[prop] = self[prop]
		return obj
	end, {}))
end

function printError(error_: GraphQLError): string
	local output = error_.message

	if error_.nodes ~= nil then
		local lengthOfNodes = #error_.nodes
		for i = 1, lengthOfNodes, 1 do
			local node = error_.nodes[i]
			if node.loc ~= nil then
				output = output .. "\n\n" .. printLocation(node.loc)
			end
		end
	elseif error_.source ~= nil and error_.locations ~= nil then
		local lengthOfLocations = #error_.locations
		for i = 1, lengthOfLocations, 1 do
			local location = error_.locations[i]
			output = output .. "\n\n" .. printSourceLocation(error_.source, location)
		end
	end

	return output
end

return {
	printError = printError,
	GraphQLError = GraphQLError,
}

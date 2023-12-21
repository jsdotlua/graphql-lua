-- ROBLOX deviation: no upstream tests
--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]

return function()
	describe("Language - init", function()
		it("should contain Source table", function()
			local Source = require("..").Source
			expect(Source).to.be.a("table")
		end)

		it("should contain getLocation function", function()
			local getLocation = require("..").getLocation
			expect(getLocation).to.be.a("function")
		end)

		it("should contain printLocation function", function()
			local printLocation = require("..").printLocation
			expect(printLocation).to.be.a("function")
		end)

		it("should contain printSourceLocation function", function()
			local printSourceLocation = require("..").printSourceLocation
			expect(printSourceLocation).to.be.a("function")
		end)

		it("should contain Kind table", function()
			local Kind = require("..").Kind
			expect(Kind).to.be.a("table")
		end)

		it("should contain TokenKind table", function()
			local TokenKind = require("..").TokenKind
			expect(TokenKind).to.be.a("table")
		end)

		it("should contain Lexer table", function()
			local Lexer = require("..").Lexer
			expect(Lexer).to.be.a("table")
		end)

		it("should contain parse function", function()
			local parse = require("..").parse
			expect(parse).to.be.a("function")
		end)

		it("should contain parseValue function", function()
			local parseValue = require("..").parseValue
			expect(parseValue).to.be.a("function")
		end)

		it("should contain parseType function", function()
			local parseType = require("..").parseType
			expect(parseType).to.be.a("function")
		end)

		it("should contain print function", function()
			local print_ = require("..").print
			expect(print_).to.be.a("function")
		end)

		it("should contain visit function", function()
			local visit = require("..").visit
			expect(visit).to.be.a("function")
		end)

		it("should contain visitInParallel function", function()
			local visitInParallel = require("..").visitInParallel
			expect(visitInParallel).to.be.a("function")
		end)

		it("should contain getVisitFn function", function()
			local getVisitFn = require("..").getVisitFn
			expect(getVisitFn).to.be.a("function")
		end)

		it("should contain BREAK table", function()
			local BREAK = require("..").BREAK
			expect(BREAK).to.be.a("table")
		end)

		it("should contain REMOVE table", function()
			local REMOVE = require("..").REMOVE
			expect(REMOVE).to.be.a("table")
		end)

		it("should contain Location table", function()
			local Location = require("..").Location
			expect(Location).to.be.a("table")
		end)

		it("should contain Token table", function()
			local Token = require("..").Token
			expect(Token).to.be.a("table")
		end)

		it("should contain isDefinitionNode function", function()
			local isDefinitionNode = require("..").isDefinitionNode
			expect(isDefinitionNode).to.be.a("function")
		end)

		it("should contain isExecutableDefinitionNode function", function()
			local isExecutableDefinitionNode = require("..").isExecutableDefinitionNode
			expect(isExecutableDefinitionNode).to.be.a("function")
		end)

		it("should contain isSelectionNode function", function()
			local isSelectionNode = require("..").isSelectionNode
			expect(isSelectionNode).to.be.a("function")
		end)

		it("should contain isValueNode function", function()
			local isValueNode = require("..").isValueNode
			expect(isValueNode).to.be.a("function")
		end)

		it("should contain isTypeNode function", function()
			local isTypeNode = require("..").isTypeNode
			expect(isTypeNode).to.be.a("function")
		end)

		it("should contain isTypeSystemDefinitionNode function", function()
			local isTypeSystemDefinitionNode = require("..").isTypeSystemDefinitionNode
			expect(isTypeSystemDefinitionNode).to.be.a("function")
		end)

		it("should contain isTypeDefinitionNode function", function()
			local isTypeDefinitionNode = require("..").isTypeDefinitionNode
			expect(isTypeDefinitionNode).to.be.a("function")
		end)

		it("should contain isTypeSystemExtensionNode function", function()
			local isTypeSystemExtensionNode = require("..").isTypeSystemExtensionNode
			expect(isTypeSystemExtensionNode).to.be.a("function")
		end)

		it("should contain isTypeExtensionNode function", function()
			local isTypeExtensionNode = require("..").isTypeExtensionNode
			expect(isTypeExtensionNode).to.be.a("function")
		end)

		it("should contain DirectiveLocation table", function()
			local DirectiveLocation = require("..").DirectiveLocation
			expect(DirectiveLocation).to.be.a("table")
		end)
	end)
end

-- ROBLOX deviation: no upstream tests

return function()
	describe("Utilities - init", function()
		it("should contain getIntrospectionQuery function", function()
			local getIntrospectionQuery = require("../init").getIntrospectionQuery
			expect(getIntrospectionQuery).to.be.a("function")
		end)

		it("should contain getOperationAST function", function()
			local getOperationAST = require("../init").getOperationAST
			expect(getOperationAST).to.be.a("function")
		end)

		it("should contain getOperationRootType function", function()
			local getOperationRootType = require("../init").getOperationRootType
			expect(getOperationRootType).to.be.a("function")
		end)

		it("should contain introspectionFromSchema function", function()
			local introspectionFromSchema = require("../init").introspectionFromSchema
			expect(introspectionFromSchema).to.be.a("function")
		end)

		it("should contain buildClientSchema function", function()
			local buildClientSchema = require("../init").buildClientSchema
			expect(buildClientSchema).to.be.a("function")
		end)

		it("should contain buildASTSchema function", function()
			local buildASTSchema = require("../init").buildASTSchema
			expect(buildASTSchema).to.be.a("function")
		end)

		it("should contain buildSchema function", function()
			local buildSchema = require("../init").buildSchema
			expect(buildSchema).to.be.a("function")
		end)

		it("should contain extendSchema function", function()
			local extendSchema = require("../init").extendSchema
			expect(extendSchema).to.be.a("function")
		end)

		it("should contain lexicographicSortSchema function", function()
			local lexicographicSortSchema = require("../init").lexicographicSortSchema
			expect(lexicographicSortSchema).to.be.a("function")
		end)

		it("should contain printSchema function", function()
			local printSchema = require("../init").printSchema
			expect(printSchema).to.be.a("function")
		end)

		it("should contain printType function", function()
			local printType = require("../init").printType
			expect(printType).to.be.a("function")
		end)

		it("should contain printIntrospectionSchema function", function()
			local printIntrospectionSchema = require("../init").printIntrospectionSchema
			expect(printIntrospectionSchema).to.be.a("function")
		end)

		it("should contain typeFromAST function", function()
			local typeFromAST = require("../init").typeFromAST
			expect(typeFromAST).to.be.a("function")
		end)

		it("should contain valueFromAST function", function()
			local valueFromAST = require("../init").valueFromAST
			expect(valueFromAST).to.be.a("function")
		end)

		it("should contain valueFromASTUntyped function", function()
			local valueFromASTUntyped = require("../init").valueFromASTUntyped
			expect(valueFromASTUntyped).to.be.a("function")
		end)

		it("should contain astFromValue function", function()
			local astFromValue = require("../init").astFromValue
			expect(astFromValue).to.be.a("function")
		end)

		it("should contain TypeInfo table", function()
			local TypeInfo = require("../init").TypeInfo
			expect(TypeInfo).to.be.a("table")
		end)

		it("should contain visitWithTypeInfo function", function()
			local visitWithTypeInfo = require("../init").visitWithTypeInfo
			expect(visitWithTypeInfo).to.be.a("function")
		end)

		it("should contain coerceInputValue function", function()
			local coerceInputValue = require("../init").coerceInputValue
			expect(coerceInputValue).to.be.a("function")
		end)

		it("should contain concatAST function", function()
			local concatAST = require("../init").concatAST
			expect(concatAST).to.be.a("function")
		end)

		it("should contain separateOperations function", function()
			local separateOperations = require("../init").separateOperations
			expect(separateOperations).to.be.a("function")
		end)

		it("should contain stripIgnoredCharacters function", function()
			local stripIgnoredCharacters = require("../init").stripIgnoredCharacters
			expect(stripIgnoredCharacters).to.be.a("function")
		end)

		it("should contain isEqualType function", function()
			local isEqualType = require("../init").isEqualType
			expect(isEqualType).to.be.a("function")
		end)

		it("should contain isTypeSubTypeOf function", function()
			local isTypeSubTypeOf = require("../init").isTypeSubTypeOf
			expect(isTypeSubTypeOf).to.be.a("function")
		end)

		it("should contain doTypesOverlap function", function()
			local doTypesOverlap = require("../init").doTypesOverlap
			expect(doTypesOverlap).to.be.a("function")
		end)

		it("should contain assertValidName function", function()
			local assertValidName = require("../init").assertValidName
			expect(assertValidName).to.be.a("function")
		end)

		it("should contain isValidNameError function", function()
			local isValidNameError = require("../init").isValidNameError
			expect(isValidNameError).to.be.a("function")
		end)

		it("should contain BreakingChangeType table", function()
			local BreakingChangeType = require("../init").BreakingChangeType
			expect(BreakingChangeType).to.be.a("table")
		end)

		it("should contain DangerousChangeType table", function()
			local DangerousChangeType = require("../init").DangerousChangeType
			expect(DangerousChangeType).to.be.a("table")
		end)

		it("should contain findBreakingChanges function", function()
			local findBreakingChanges = require("../init").findBreakingChanges
			expect(findBreakingChanges).to.be.a("function")
		end)

		it("should contain findDangerousChanges function", function()
			local findDangerousChanges = require("../init").findDangerousChanges
			expect(findDangerousChanges).to.be.a("function")
		end)
	end)
end

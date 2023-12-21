--[[
 * Copyright (c) GraphQL Contributors
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
]]
-- ROBLOX upstream: https://github.com/graphql/graphql-js/blob/00d4efea7f5b44088356798afff0317880605f4d/src/utilities/__tests__/lexicographicSortSchema-test.js

return function()
	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	local dedent = require("../../__testUtils__/dedent").dedent

	local printSchema = require("../printSchema").printSchema
	local buildSchema = require("../buildASTSchema").buildSchema
	local lexicographicSortSchema =
		require("../lexicographicSortSchema").lexicographicSortSchema

	local function sortSDL(sdl)
		local schema = buildSchema(sdl)

		return printSchema(lexicographicSortSchema(schema))
	end

	describe("lexicographicSortSchema", function()
		it("sort fields", function()
			local sorted = sortSDL([[

      input Bar {
        barB: String!
        barA: String
        barC: [String]
      }

      interface FooInterface {
        fooB: String!
        fooA: String
        fooC: [String]
      }

      type FooType implements FooInterface {
        fooC: [String]
        fooA: String
        fooB: String!
      }

      type Query {
        dummy(arg: Bar): FooType
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      input Bar {
        barA: String
        barB: String!
        barC: [String]
      }

      interface FooInterface {
        fooA: String
        fooB: String!
        fooC: [String]
      }

      type FooType implements FooInterface {
        fooA: String
        fooB: String!
        fooC: [String]
      }

      type Query {
        dummy(arg: Bar): FooType
      }
    ]]))
		end)

		it("sort implemented interfaces", function()
			local sorted = sortSDL([[

      interface FooA {
        dummy: String
      }

      interface FooB {
        dummy: String
      }

      interface FooC implements FooB & FooA {
        dummy: String
      }

      type Query implements FooB & FooA & FooC {
        dummy: String
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      interface FooA {
        dummy: String
      }

      interface FooB {
        dummy: String
      }

      interface FooC implements FooA & FooB {
        dummy: String
      }

      type Query implements FooA & FooB & FooC {
        dummy: String
      }
    ]]))
		end)

		it("sort types in union", function()
			local sorted = sortSDL([[

      type FooA {
        dummy: String
      }

      type FooB {
        dummy: String
      }

      type FooC {
        dummy: String
      }

      union FooUnion = FooB | FooA | FooC

      type Query {
        dummy: FooUnion
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      type FooA {
        dummy: String
      }

      type FooB {
        dummy: String
      }

      type FooC {
        dummy: String
      }

      union FooUnion = FooA | FooB | FooC

      type Query {
        dummy: FooUnion
      }
    ]]))
		end)

		it("sort enum values", function()
			local sorted = sortSDL([[

      enum Foo {
        B
        C
        A
      }

      type Query {
        dummy: Foo
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      enum Foo {
        A
        B
        C
      }

      type Query {
        dummy: Foo
      }
    ]]))
		end)

		it("sort field arguments", function()
			local sorted = sortSDL([[

      type Query {
        dummy(argB: Int!, argA: String, argC: [Float]): ID
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      type Query {
        dummy(argA: String, argB: Int!, argC: [Float]): ID
      }
    ]]))
		end)

		it("sort types", function()
			local sorted = sortSDL([[

      type Query {
        dummy(arg1: FooF, arg2: FooA, arg3: FooG): FooD
      }

      type FooC implements FooE {
        dummy: String
      }

      enum FooG {
        enumValue
      }

      scalar FooA

      input FooF {
        dummy: String
      }

      union FooD = FooC | FooB

      interface FooE {
        dummy: String
      }

      type FooB {
        dummy: String
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      scalar FooA

      type FooB {
        dummy: String
      }

      type FooC implements FooE {
        dummy: String
      }

      union FooD = FooB | FooC

      interface FooE {
        dummy: String
      }

      input FooF {
        dummy: String
      }

      enum FooG {
        enumValue
      }

      type Query {
        dummy(arg1: FooF, arg2: FooA, arg3: FooG): FooD
      }
    ]]))
		end)

		it("sort directive arguments", function()
			local sorted = sortSDL([[

      directive @test(argC: Float, argA: String, argB: Int) on FIELD

      type Query {
        dummy: String
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      directive @test(argA: String, argB: Int, argC: Float) on FIELD

      type Query {
        dummy: String
      }
    ]]))
		end)

		it("sort directive locations", function()
			local sorted = sortSDL([[

      directive @test(argC: Float, argA: String, argB: Int) on UNION | FIELD | ENUM

      type Query {
        dummy: String
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      directive @test(argA: String, argB: Int, argC: Float) on ENUM | FIELD | UNION

      type Query {
        dummy: String
      }
    ]]))
		end)

		it("sort directives", function()
			local sorted = sortSDL([[

      directive @fooC on FIELD

      directive @fooB on UNION

      directive @fooA on ENUM

      type Query {
        dummy: String
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      directive @fooA on ENUM

      directive @fooB on UNION

      directive @fooC on FIELD

      type Query {
        dummy: String
      }
    ]]))
		end)

		it("sort recursive types", function()
			local sorted = sortSDL([[

      interface FooC {
        fooB: FooB
        fooA: FooA
        fooC: FooC
      }

      type FooB implements FooC {
        fooB: FooB
        fooA: FooA
      }

      type FooA implements FooC {
        fooB: FooB
        fooA: FooA
      }

      type Query {
        fooC: FooC
        fooB: FooB
        fooA: FooA
      }
    ]])

			jestExpect(sorted).toEqual(dedent([[

      type FooA implements FooC {
        fooA: FooA
        fooB: FooB
      }

      type FooB implements FooC {
        fooA: FooA
        fooB: FooB
      }

      interface FooC {
        fooA: FooA
        fooB: FooB
        fooC: FooC
      }

      type Query {
        fooA: FooA
        fooB: FooB
        fooC: FooC
      }
    ]]))
		end)
	end)
end

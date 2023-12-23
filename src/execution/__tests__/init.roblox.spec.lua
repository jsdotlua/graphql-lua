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
-- ROBLOX deviation: no upstream tests

return function()
	describe("Execute - init", function()
		it("should contain execute function", function()
			local execute = require("../init").execute
			expect(execute).to.be.a("function")
		end)

		it("should contain executeSync function", function()
			local executeSync = require("../init").executeSync
			expect(executeSync).to.be.a("function")
		end)

		it("should contain defaultFieldResolver function", function()
			local defaultFieldResolver = require("../init").defaultFieldResolver
			expect(defaultFieldResolver).to.be.a("function")
		end)

		it("should contain defaultTypeResolver function", function()
			local defaultTypeResolver = require("../init").defaultTypeResolver
			expect(defaultTypeResolver).to.be.a("function")
		end)

		it("should contain getDirectiveValues function", function()
			local getDirectiveValues = require("../init").getDirectiveValues
			expect(getDirectiveValues).to.be.a("function")
		end)
	end)
end

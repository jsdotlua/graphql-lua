--[[
 * Copyright (c) GraphQL Contributors
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
]]
-- ROBLOX upstream: https://github.com/graphql/graphql-js/blob/7b3241329e1ff49fb647b043b80568f0cf9e1a7c/src/validation/index.js

local ValidationContextModule = require("./ValidationContext")

export type ValidationRule = ValidationContextModule.ValidationRule
export type ASTValidationContext = ValidationContextModule.ASTValidationContext
export type SDLValidationContext = ValidationContextModule.SDLValidationContext
export type ValidationContext = ValidationContextModule.ValidationContext

return {
	validate = require("./validate").validate,

	ValidationContext = ValidationContextModule.ValidationContext,

	-- // All validation rules in the GraphQL Specification.
	specifiedRules = require("./specifiedRules").specifiedRules,

	-- // Spec Section: "Executable Definitions"
	ExecutableDefinitionsRule = require("./rules/ExecutableDefinitionsRule").ExecutableDefinitionsRule,

	-- // Spec Section: "Field Selections on Objects, Interfaces, and Unions Types"
	FieldsOnCorrectTypeRule = require("./rules/FieldsOnCorrectTypeRule").FieldsOnCorrectTypeRule,

	-- // Spec Section: "Fragments on Composite Types"
	FragmentsOnCompositeTypesRule = require("./rules/FragmentsOnCompositeTypesRule").FragmentsOnCompositeTypesRule,

	-- // Spec Section: "Argument Names"
	KnownArgumentNamesRule = require("./rules/KnownArgumentNamesRule").KnownArgumentNamesRule,

	-- // Spec Section: "Directives Are Defined"
	KnownDirectivesRule = require("./rules/KnownDirectivesRule").KnownDirectivesRule,

	-- // Spec Section: "Fragment spread target defined"
	KnownFragmentNamesRule = require("./rules/KnownFragmentNamesRule").KnownFragmentNamesRule,

	-- // Spec Section: "Fragment Spread Type Existence"
	KnownTypeNamesRule = require("./rules/KnownTypeNamesRule").KnownTypeNamesRule,

	-- // Spec Section: "Lone Anonymous Operation"
	LoneAnonymousOperationRule = require("./rules/LoneAnonymousOperationRule").LoneAnonymousOperationRule,

	-- // Spec Section: "Fragments must not form cycles"
	NoFragmentCyclesRule = require("./rules/NoFragmentCyclesRule").NoFragmentCyclesRule,

	-- // Spec Section: "All Variable Used Defined"
	NoUndefinedVariablesRule = require("./rules/NoUndefinedVariablesRule").NoUndefinedVariablesRule,

	-- // Spec Section: "Fragments must be used"
	NoUnusedFragmentsRule = require("./rules/NoUnusedFragmentsRule").NoUnusedFragmentsRule,

	-- // Spec Section: "All Variables Used"
	NoUnusedVariablesRule = require("./rules/NoUnusedVariablesRule").NoUnusedVariablesRule,

	-- // Spec Section: "Field Selection Merging"
	OverlappingFieldsCanBeMergedRule = require("./rules/OverlappingFieldsCanBeMergedRule").OverlappingFieldsCanBeMergedRule,

	-- // Spec Section: "Fragment spread is possible"
	PossibleFragmentSpreadsRule = require("./rules/PossibleFragmentSpreadsRule").PossibleFragmentSpreadsRule,

	-- // Spec Section: "Argument Optionality"
	ProvidedRequiredArgumentsRule = require("./rules/ProvidedRequiredArgumentsRule").ProvidedRequiredArgumentsRule,

	-- // Spec Section: "Leaf Field Selections"
	ScalarLeafsRule = require("./rules/ScalarLeafsRule").ScalarLeafsRule,

	-- // Spec Section: "Subscriptions with Single Root Field"
	SingleFieldSubscriptionsRule = require("./rules/SingleFieldSubscriptionsRule").SingleFieldSubscriptionsRule,

	-- // Spec Section: "Argument Uniqueness"
	UniqueArgumentNamesRule = require("./rules/UniqueArgumentNamesRule").UniqueArgumentNamesRule,

	-- // Spec Section: "Directives Are Unique Per Location"
	UniqueDirectivesPerLocationRule = require("./rules/UniqueDirectivesPerLocationRule").UniqueDirectivesPerLocationRule,

	-- // Spec Section: "Fragment Name Uniqueness"
	UniqueFragmentNamesRule = require("./rules/UniqueFragmentNamesRule").UniqueFragmentNamesRule,

	-- // Spec Section: "Input Object Field Uniqueness"
	UniqueInputFieldNamesRule = require("./rules/UniqueInputFieldNamesRule").UniqueInputFieldNamesRule,

	-- // Spec Section: "Operation Name Uniqueness"
	UniqueOperationNamesRule = require("./rules/UniqueOperationNamesRule").UniqueOperationNamesRule,

	-- // Spec Section: "Variable Uniqueness"
	UniqueVariableNamesRule = require("./rules/UniqueVariableNamesRule").UniqueVariableNamesRule,

	-- // Spec Section: "Values Type Correctness"
	ValuesOfCorrectTypeRule = require("./rules/ValuesOfCorrectTypeRule").ValuesOfCorrectTypeRule,

	-- // Spec Section: "Variables are Input Types"
	VariablesAreInputTypesRule = require("./rules/VariablesAreInputTypesRule").VariablesAreInputTypesRule,

	-- // Spec Section: "All Variable Usages Are Allowed"
	VariablesInAllowedPositionRule = require("./rules/VariablesInAllowedPositionRule").VariablesInAllowedPositionRule,

	-- // SDL-specific validation rules
	LoneSchemaDefinitionRule = require("./rules/LoneSchemaDefinitionRule").LoneSchemaDefinitionRule,
	UniqueOperationTypesRule = require("./rules/UniqueOperationTypesRule").UniqueOperationTypesRule,
	UniqueTypeNamesRule = require("./rules/UniqueTypeNamesRule").UniqueTypeNamesRule,
	UniqueEnumValueNamesRule = require("./rules/UniqueEnumValueNamesRule").UniqueEnumValueNamesRule,
	UniqueFieldDefinitionNamesRule = require("./rules/UniqueFieldDefinitionNamesRule").UniqueFieldDefinitionNamesRule,
	UniqueDirectiveNamesRule = require("./rules/UniqueDirectiveNamesRule").UniqueDirectiveNamesRule,
	PossibleTypeExtensionsRule = require("./rules/PossibleTypeExtensionsRule").PossibleTypeExtensionsRule,

	-- // Optional rules not defined by the GraphQL Specification
	NoDeprecatedCustomRule = require("./rules/custom/NoDeprecatedCustomRule").NoDeprecatedCustomRule,
	NoSchemaIntrospectionCustomRule = require("./rules/custom/NoSchemaIntrospectionCustomRule").NoSchemaIntrospectionCustomRule,
}

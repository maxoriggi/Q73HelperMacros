//
//  EnvironmentKeyMacro.swift
//
//
//  Created by Massimiliano Origgi on 11/04/24.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EnvironmentKeyMacro: DeclarationMacro {
	static public var formatMode: FormatMode {
		return .disabled
	}

	static public func expansion(
		of node: some FreestandingMacroExpansionSyntax,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		guard let varDecls = getVariableDeclarations(node.trailingClosure?.statements) else {
			context.diagnose(Diagnostic(node: Syntax(node), message: Feedback.noTrailingClosure))
			return []
		}

		return varDecls.flatMap {
			generatePair($0, context: context, node: node)
		}
	}

	static func getVariableDeclarations(_ closureBody: CodeBlockItemListSyntax?) -> [VariableDeclSyntax]? {
		guard let closureBody else { return nil }

		return closureBody.compactMap { $0.item.as(VariableDeclSyntax.self) }
	}

	static func generatePair(_ varDecl: VariableDeclSyntax, context: some MacroExpansionContext, node: some FreestandingMacroExpansionSyntax) -> [DeclSyntax] {
		guard let binding = varDecl.bindings.first,
			  let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
			return []
		}

		guard let type = binding.typeAnnotation?.type else {
			context.diagnose(Diagnostic(node: Syntax(node), message: Feedback.noTypeProvided))
			return []
		}

		guard let initialiser = binding.initializer?.value else {
			context.diagnose(Diagnostic(node: Syntax(node), message: Feedback.noDefaultValue))
			return []
		}

		let structName = "\(name.text.capitalized)EnvironmentKey"
		let keyStruct: DeclSyntax =
			"""

			var \(name): \(type){
				get {
					self[\(raw: structName).self]
				}
				set {
					self[\(raw: structName).self] = newValue
				}
			}
			"""

		let backingProperty: DeclSyntax =
			"""

			internal struct \(raw: structName): EnvironmentKey {
				static var defaultValue: \(type)= \(initialiser)
			}
			"""

		return [keyStruct, backingProperty]
	}
}

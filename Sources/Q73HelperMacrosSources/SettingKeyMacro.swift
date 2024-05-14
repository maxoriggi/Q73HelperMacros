//
//  SettingKeyMacro.swift
//  
//
//  Created by Massimiliano Origgi on 11/04/24.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SettingKeyMacro: DeclarationMacro {
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
		let suiteExpr = node.argumentList.first?.expression

		return varDecls.flatMap {
			generatePair($0, context: context, suiteExpr: suiteExpr)
		}
	}

	static func getVariableDeclarations(_ closureBody: CodeBlockItemListSyntax?) -> [VariableDeclSyntax]? {
		guard let closureBody else { return nil }

		return closureBody.compactMap { $0.item.as(VariableDeclSyntax.self) }
	}

	static func generatePair(_ varDecl: VariableDeclSyntax, context: some MacroExpansionContext, suiteExpr: ExprSyntax?) -> [DeclSyntax] {
		guard let binding = varDecl.bindings.first,
			  let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
			return []
		}

		guard let type = binding.typeAnnotation?.type else {
			context.diagnose(Diagnostic(node: Syntax(varDecl), message: Feedback.noTypeProvided))
			return []
		}

		guard let initialiser = binding.initializer?.value else {
			context.diagnose(Diagnostic(node: Syntax(varDecl), message: Feedback.noDefaultValue))
			return []
		}

		let varName = "\(name.text)"
		let varType = "\(type)".trimmingCharacters(in: .whitespaces)
		let suite = suiteExpr != nil ? ", suite: \(suiteExpr!)" : ""
		let backingProperty: DeclSyntax =
		"""

		static let \(raw: varName) = Key<\(raw: varType)>("\(raw: varName)", default: \(initialiser)\(raw: suite))
		"""

		return [backingProperty]
	}
}

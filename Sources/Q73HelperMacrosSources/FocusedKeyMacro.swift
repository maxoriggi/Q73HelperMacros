import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FocusedKeyMacro: DeclarationMacro {
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
//			  let initialiser = binding.initializer?.value,
			  let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
			return []
		}

		guard let type = binding.typeAnnotation?.type else {
			context.diagnose(Diagnostic(node: Syntax(node), message: Feedback.noTypeProvided))
			return []
		}


		let structName = "\(name.text.capitalized)Values"
		let keyStruct: DeclSyntax = 
			"""
			
			struct \(raw: structName): FocusedValueKey {
				typealias Value = \(type)
			}
			"""

		let backingProperty: DeclSyntax = 
			"""
			
			var \(name): \(raw: structName).Value? {
				get {
					self[\(raw: structName).self]
				}
				set {
					self[\(raw: structName).self] = newValue
				}
			}
			"""

		return [keyStruct, backingProperty]
	}
}

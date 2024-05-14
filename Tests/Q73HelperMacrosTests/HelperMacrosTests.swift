import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Q73HelperMacros)
import Q73HelperMacrosSources

let testMacros: [String: Macro.Type] = [
    "focusedKey": FocusedKeyMacro.self,
	"settingKey": SettingKeyMacro.self
]
#endif

final class Q73MacrosTests: XCTestCase {
    func testMacro() throws {
        #if canImport(Q73HelperMacros)
        assertMacroExpansion(
			"""
			#withfocusedValueKey {
				var myKey: Int
			}
			""",
            expandedSource:
				"""
				struct MykeyValues: FocusedValueKey {
					typealias Value = Int
				}
				var myKey: MykeyValues.Value? {
					get {
						self[MykeyValues.self]
					}
					set {
						self[MykeyValues.self] = newValue
					}
				}
				""",
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

	func testMacro2() throws {
#if canImport(Q73HelperMacros)
		assertMacroExpansion(
			"""
			#withSettingKey {
				var quality: Double = 0.8
			}
			""",
			expandedSource:
				"""
				static let quality = Key<Double>("quality", default: 0.8)
				""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}

}

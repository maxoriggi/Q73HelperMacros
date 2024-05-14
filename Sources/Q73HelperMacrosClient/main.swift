import Defaults
import Q73HelperMacros
import SwiftUI


extension FocusedValues {
	#withfocusedValueKey {
		var myKey: Int = 1
		var myKey2: String
	}
}

extension EnvironmentValues {
	#withEnvironmentKey {
		var myEnv: Int = 1
		var myEnv2: String = "aaa"
	}
}

extension Defaults.Keys {
	#withSettingKey(suite: .standard) {
		var test: Int = 2
	}
}

print(Defaults[.test])

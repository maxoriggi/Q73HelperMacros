//
//  File.swift
//  
//
//  Created by Massimiliano Origgi on 11/04/24.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros


@main
struct Q73HelperMacrosPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		FocusedKeyMacro.self,
		EnvironmentKeyMacro.self,
		SettingKeyMacro.self
	]
}

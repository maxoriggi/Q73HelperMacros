// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@freestanding(declaration, names: arbitrary)
public macro withfocusedValueKey(_ f: () -> Void) = #externalMacro(module: "Q73HelperMacrosSources", type: "FocusedKeyMacro")

@freestanding(declaration, names: arbitrary)
public macro withEnvironmentKey(_ f: () -> Void) = #externalMacro(module: "Q73HelperMacrosSources", type: "EnvironmentKeyMacro")

@freestanding(declaration, names: arbitrary)
public macro withSettingKey(suite: UserDefaults? = nil, _ f: () -> Void) = #externalMacro(module: "Q73HelperMacrosSources", type: "SettingKeyMacro")

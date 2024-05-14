//
//  File.swift
//  
//
//  Created by Massimiliano Origgi on 11/04/24.
//

import SwiftSyntax
import SwiftDiagnostics

enum Feedback: String, DiagnosticMessage {
	case noTrailingClosure
	case noTypeProvided
	case noDefaultValue

	case noDefaultArgument
	case defaultArgument
	case missingAnnotation
	case notAnIdentifier

	var severity: DiagnosticSeverity { return .error }

	var message: String {
		switch self {
			case .noDefaultArgument:
				"No default value provided."
			case .defaultArgument:
				"Must not have a default value."
			case .missingAnnotation:
				"No annotation provided."
			case .notAnIdentifier:
				"Identifier is not valid."
			
			case .noTrailingClosure:
				"No trailing closure with variable decls provided."
			case .noTypeProvided:
				"No type provided in variable declaration."
			case .noDefaultValue:
				"No default value provided in variable declaration."
		}
	}

	var diagnosticID: MessageID {
		MessageID(domain: "Q73HelperMacros", id: rawValue)
	}
}

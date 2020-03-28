//
//  RunError.swift
//  proj1
//
//  Created by Filip Klembara on 17/02/2020.
//

enum RunError: Error {
    case notAccepted
    case wrongArgs
    case fileErr
    case decodeErr
    case undefinedState
    case undefinedSymbol
    case nonDeterministicAutomata
    case internalErr
    case notImplemented
}

// MARK: - Return codes
extension RunError {
    var code: Int {
        switch self {
        case .notImplemented:
            return 66
        case .notAccepted:
            return 6
        case .wrongArgs:
            return 11
        case .fileErr:
            return 12
        case .decodeErr:
            return 20
        case .undefinedState:
            return 21
        case .undefinedSymbol:
            return 22
        case .nonDeterministicAutomata:
            return 23
        case .internalErr:
            return 99
        }
    }
}

// MARK:- Description of error
extension RunError: CustomStringConvertible {
    var description: String {
        switch self {
        case .notImplemented:
            return "Not implemented"
        case .notAccepted:
            return "The input is not accepted"
        case .wrongArgs:
            return "Wrong arguments"
        case .fileErr:
            return "Error occured while working with the file"
        case .decodeErr:
            return "Decoding automata wasn't successful"
        case .undefinedState:
            return "Undefined state"
        case .undefinedSymbol:
            return "Undefined symbol"
        case .nonDeterministicAutomata:
            return "Automata is not deterministic"
        case .internalErr:
            return "Internal error"
        }
    }
}

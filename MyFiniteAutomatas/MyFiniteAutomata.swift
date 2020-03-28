//
//  MyFiniteAutomata.swift
//  MyFiniteAutomatas
//
//  Created by Filip Klembara on 17/02/2020.
//

import Foundation

/// String description of automata
public protocol MyStringConvertibleAutomata {
    /// JSON description of automata
    static var description: StaticString { get }
}

/// Set of valid and invalid inputs
public protocol MyAutomataInputs {
    /// Valid inputs, `input` - string accepted by automata, `states` expected states
    static var valid: [(input: String, states: [String])] { get }

    /// Invalid inputs
    static var invalid: [String] { get }
}

extension MyStringConvertibleAutomata {
    /// Convert JSON description to `Data`
    public static var data: Data {
        description.description.data(using: .utf8)!
    }
}

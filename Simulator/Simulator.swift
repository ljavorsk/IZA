//
//  Simulator.swift
//  Simulator
//
//  Created by Filip Klembara on 17/02/2020.
//

import FiniteAutomata

/// Simulator
public struct Simulator {
    /// Finite automata used in simulations
    private let finiteAutomata: FiniteAutomata

    /// Initialize simulator with given automata
    /// - Parameter finiteAutomata: finite automata
    public init(finiteAutomata: FiniteAutomata) {
        self.finiteAutomata = finiteAutomata
    }

    /// Simulate automata on given string
    /// - Parameter string: string with symbols separated by ','
    /// - Returns: Empty array if given string is not accepted by automata,
    ///     otherwise array of states
    public func simulate(on string: String) -> [String] {
        let symbols = string.split(separator: ",")
        var result: [String] = [finiteAutomata.initialState]
        var currentState = finiteAutomata.initialState
        
        for symbol in symbols {
            // Flag thats set to true if the symbol was accepted
            var wasAccepted = false
            for transition in self.finiteAutomata.transitions {
                if transition.with == symbol && transition.from == currentState {
                    wasAccepted = true
                    // Do transition
                    currentState = transition.to
                    result.append(currentState)
                    break
                }
            }
            if !wasAccepted {
                // The symbol wasn't accepted
                return []
            }
        }
        if finiteAutomata.finalStates.contains(currentState) {
            return result
        }
        // The last known state wasn't finite
        return []
    }
}

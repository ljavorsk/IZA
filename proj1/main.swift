//
//  main.swift
//  proj1
//
//  Created by Filip Klembara on 17/02/2020.
//

import Foundation
import FiniteAutomata
import Simulator

struct Arguments{
    var automataInput: String
    var fileName: String
}

// MARK: - Main
func main() -> Result<Void, RunError> {
    
    if CommandLine.argc == 3 {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[2]))
            do {
                let automata = try JSONDecoder().decode(FiniteAutomata.self, from: data)
                let validSymbols = automata.symbols
                let validStates = automata.states
                var possibleDetermTransitions = [[String]]()
                
                // Build the 2D array of possible transitions for DFA
                for state in automata.states {
                    for symbol in automata.symbols {
                        possibleDetermTransitions.append([state + ">" + symbol])
                    }
                }
                
                // Tests before simulation
                for t in automata.transitions {
                    // Test for the invalid symbols
                    if !validSymbols.contains(t.with) {
                        return .failure(.undefinedSymbol)
                    }
                    // Test for the invalid states
                    if !validStates.contains(t.from) {
                        return .failure(.undefinedState)
                    }
                    if !validStates.contains(t.to) {
                        return .failure(.undefinedState)
                    }
                    // Test if the automata is DFA
                    if possibleDetermTransitions.contains([String(t.from + ">" + t.with)]){
                        // Deletes the transition from array
                        possibleDetermTransitions = possibleDetermTransitions.filter { $0 != [String(t.from + ">" + t.with)] }
                    } else {    // Transition was already used = NDFA
                        return .failure(.nonDeterministicAutomata)
                    }
                }   // Symbols, states are valid and the automata is DFA
                
                let simulator = Simulator(finiteAutomata: automata)
                let sequence = simulator.simulate(on: CommandLine.arguments[1])
                if sequence.isEmpty {
                    return .failure(.notAccepted)
                } else {
                    // Everything was accepted
                    for steppedState in sequence {
                        print(steppedState)
                    }
                    return .success(Void())
                }
            } catch { return .failure(.decodeErr) }
        } catch { return .failure(.fileErr) }
    }
    return .failure(.wrongArgs)
}

// MARK: - program body
let result = main()

switch result {
case .success:
    break
case .failure(let error):
    var stderr = STDERRStream()
    print("Error:", error.description, to: &stderr)
    exit(Int32(error.code))
}

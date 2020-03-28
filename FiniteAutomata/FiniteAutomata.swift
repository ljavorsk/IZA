//
//  FiniteAutomata.swift
//  FiniteAutomata
//
//  Created by Filip Klembara on 17/02/2020.
//
import Foundation

public struct Transition: Codable {
    public var with: String
    public var to: String
    public var from: String
}

/// Finite automata
public struct FiniteAutomata {
    public var states: [String]
    public var symbols: [String]
    public var transitions: [Transition]
    public var initialState: String
    public var finalStates: [String]
}

extension FiniteAutomata: Decodable {
    enum FiniteAutomataCoding: String, CodingKey{
        case states
        case symbols
        case transitions
        case initialState
        case finalStates
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FiniteAutomataCoding.self)
        states = try values.decode([String].self, forKey: .states)
        symbols = try values.decode([String].self, forKey: .symbols)
        transitions = try values.decode([Transition].self, forKey: .transitions)
        initialState = try values.decode(String.self, forKey: .initialState)
        finalStates = try values.decode([String].self, forKey: .finalStates)
    }
}

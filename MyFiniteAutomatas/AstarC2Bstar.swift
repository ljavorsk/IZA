//
//  AstarC2Bstar.swift
//  MyFiniteAutomatas
//
//  Created by Filip Klembara on 17/02/2020.
//

public struct AstarC2Bstar {
    private init() { }
}

extension AstarC2Bstar: MyAutomataInputs {
    public static var valid: [(input: String, states: [String])] = [
        ("a,a,c,c,b,b,b", ["A", "A", "A", "C", "B", "B", "B", "B"]),
        ("c,c", ["A", "C", "B"]),
    ]

    public static var invalid: [String] = [
        "a,a,c,b,b,b",
        "c",
    ]
}

extension AstarC2Bstar: MyStringConvertibleAutomata {
    public static var description: StaticString = #"""
{
  "states" : [
    "C",
    "A",
    "B"
  ],
  "symbols" : [
    "c",
    "a",
    "b"
  ],
  "transitions" : [
    {
      "with" : "c",
      "to" : "B",
      "from" : "C"
    },
    {
      "with" : "b",
      "to" : "B",
      "from" : "B"
    },
    {
      "with" : "c",
      "to" : "C",
      "from" : "A"
    },
    {
      "with" : "a",
      "to" : "A",
      "from" : "A"
    }
  ],
  "initialState" : "A",
  "finalStates" : [
    "B"
  ]
}
"""#
}

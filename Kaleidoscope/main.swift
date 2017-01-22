//
//  main.swift
//  Kaleidoscope
//
//  Created by Patrick Goley on 1/19/17.
//
//

import Foundation

let source = "extern sqrt(n); def foo(n) (n * sqrt(n * 200) + 57 * n % 2);"

let tokens = Lexer(input: source).lex()

let tokensString = tokens.map { $0.description }.joined(separator: " ")

let topLevel = try? Parser(tokens: tokens).parseTopLevel()

print("top level:\n", topLevel ?? "nil")

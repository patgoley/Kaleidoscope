//
//  Token.swift
//  Kaleidoscope
//
//  Created by Patrick Goley on 1/20/17.
//
//

import Foundation

enum Token: CustomStringConvertible, Equatable {
    
    case leftParen, rightParen, comma, semicolon
    case keyword(Keyword)
    case identifier(String)
    case number(Double)
    case `operator`(BinaryOperator)
    
    static let singleCharTokens: [UnicodeScalar: Token] = [
        ",": .comma, "(": .leftParen, ")": .rightParen,
        ";": .semicolon, "+": .operator(.plus),
        "-": .operator(.minus), "*": .operator(.times),
        "/": .operator(.divide), "%": .operator(.mod)
    ]
    
    var description: String {
        
        switch self {
        case .leftParen: return "("
        case .rightParen: return ")"
        case .comma: return ","
        case .semicolon: return ";"
        case .keyword(let word): return word.rawValue
        case .identifier(let word): return word
        case .number(let num): return String(num)
        case .operator(let op): return String(op.rawValue)
        }
    }
    
    static func ==(lhs: Token, rhs: Token) -> Bool {
        
        switch (lhs, rhs) {
            
        case (.leftParen, .leftParen),
             (.rightParen, .rightParen),
             (.comma, .comma),
             (.semicolon, .semicolon):
            return true
        case let (.identifier(id1), .identifier(id2)):
            return id1 == id2
        case let (.number(n1), .number(n2)):
            return n1 == n2
        case let (.operator(op1), .operator(op2)):
            return op1 == op2
        case let (.keyword(keyword1), .keyword(keyword2)):
            return keyword1 == keyword2
        default:
            return false
        }
    }
}

extension Array where Element: CustomStringConvertible {
    
    public func spaceJoined() -> String {
        
        return reduce("") { prev, elem in
         
            return prev + " " + elem.description
        }
    }
}

//
//  Lexer.swift
//  Kaleidoscope
//
//  Created by Patrick Goley on 1/20/17.
//
//

import Foundation


class Lexer {
    
    let input: [UnicodeScalar]
    var index = 0
    
    init(input: String) {
        
        self.input = Array(input.unicodeScalars)
    }
    
    func lex() -> [Token] {
        
        var tokens: [Token] = []
        
        while let token = advanceToNextToken() {
            
            tokens.append(token)
        }
        
        return tokens
    }
    
    var currentChar: UnicodeScalar? {
        
        return index < input.count ? input[index] : nil
    }
    
    func advanceIndex() {
        
        index += 1
    }
    
    func readIdentifier() -> String {
        var str = ""
        while let char = currentChar, char.isAlphanumeric {
            str.unicodeScalars.append(char)
            advanceIndex()
        }
        return str
    }
    
    func advanceToNextToken() -> Token? {
        
        while let char = currentChar, char.isSpace {
            
            advanceIndex()
        }
        
        guard let char = currentChar else {
            
            // end of input
            
            return nil
        }
        
        if let token = Token.singleCharTokens[char] {
            
            advanceIndex()
            
            return token
        }
        
        if char.isAlphanumeric {
            
            var str = readIdentifier()
            
            if Int(str) != nil {
                
                let backtrackIndex = index
                
                if currentChar == "." {
                    
                    advanceIndex()
                    
                    let decimalStr = readIdentifier()
                    
                    if Int(str) != nil {
                        
                        str.append(".")
                        
                        str += decimalStr
                        
                    } else {
                        
                        index = backtrackIndex
                    }
                }
                
                return .number(Double(str)!)
            }
            
            return Keyword(rawValue: str).map(Token.keyword) ?? .identifier(str)
        }
        
        return nil
    }
}

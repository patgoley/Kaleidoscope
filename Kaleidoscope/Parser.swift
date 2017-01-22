//
//  Parser.swift
//  Kaleidoscope
//
//  Created by Patrick Goley on 1/21/17.
//
//

import Foundation


class Parser {
    
    let tokens: [Token]
    
    var index = 0
    
    init(tokens: [Token]) {
        
        self.tokens = tokens
    }
    
    var currentToken: Token? {
        
        return index < tokens.count ? tokens[index] : nil
    }
    
    func parseTopLevel() throws -> TopLevel {
        
        do {
            
            var externs = [Prototype]()
            var definitions = [Definition]()
            
            while let tok = currentToken {
                
                switch tok {
                    
                case .keyword(.extern):
                    externs.append(try parseExtern())
                    
                case .keyword(.def):
                    definitions.append(try parseDefinition())
                    
                default:
                    throw ParseError.unexpectedToken(tok)
                }
            }
            
            return TopLevel(externs: externs, definitions: definitions)
            
        } catch (let error) {
            
            let validSource = tokens[0...index - 1].map { $0.description }.spaceJoined()
            
            print("Parse error: ", error, "Source:\n", validSource, "^")
            
            throw error
            
        }
    }
    
    func parseIdentifier() throws -> String {
        
        guard let token = currentToken else {
            
            throw ParseError.unexpectedEOF
        }
        
        guard case .identifier(let name) = token else {
            
            throw ParseError.unexpectedToken(token)
        }
        
        advance()
        
        return name
    }
    
    func parsePrototype() throws -> Prototype {
        
        let name = try parseIdentifier()
        
        let params = try parseCommaSeparated(parseIdentifier)
        
        return Prototype(name: name, params: params)
    }
    
    func parseExtern() throws -> Prototype {
        
        try parse(.keyword(.extern))
        
        let proto = try parsePrototype()
        
        try parse(.semicolon)
        
        return proto
    }
    
    func parseDefinition() throws -> Definition {
        
        try parse(.keyword(.def))
        
        let proto = try parsePrototype()
        
        let expr = try parseExpression()
        
        let definition = Definition(prototype: proto, expression: expr)
        
        try parse(.semicolon)
        
        return definition
    }
    
    func parseCommaSeparated<TermType>(_ parseFn: () throws -> TermType) throws -> [TermType] {
        
        try parse(.leftParen)
        
        var vals = [TermType]()
        
        while let tok = currentToken, tok != .rightParen {
            
            let val = try parseFn()
            
            if case .comma? = currentToken {
                
                try parse(.comma)
            }
            
            vals.append(val)
        }
        
        try parse(.rightParen)
        
        return vals
    }
    
    func parseExpression() throws -> Expression {
        
        guard let token = currentToken else {
            
            throw ParseError.unexpectedEOF
        }
        
        var expression: Expression
        
        switch token {
            
        case .leftParen:
            
            advance()
            
            expression = try parseExpression()
            
            try parse(.rightParen)
            
        case .number(let value):
            
            advance()
            
            expression = .number(value)
            
        case .identifier(let identifier):
            
            advance()
            
            if case .leftParen? = currentToken {
                
                let params = try parseCommaSeparated(parseExpression)
                
                expression = .call(identifier, params)
                
            } else {
                
                expression = .variable(identifier)
            }
            
        default:
            
            throw ParseError.unexpectedToken(token)
        }
        
        if case .operator(let op)? = currentToken {
            
            advance()
            
            let rhs = try parseExpression()
            
            expression = .binary(expression, op, rhs)
        }
        
        return expression
    }
    
    func parse(_ token: Token) throws {
        
        guard let tok = currentToken else {
            
            throw ParseError.unexpectedEOF
        }
        
        guard token == tok else {
            
            throw ParseError.unexpectedToken(token)
        }
        
        advance()
    }
    
    func advance(n: Int = 1) {
        
        index += n
    }
}

enum ParseError: Error {
    
    case unexpectedToken(Token)
    case unexpectedEOF
}

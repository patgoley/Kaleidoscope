//
//  Expression.swift
//  Kaleidoscope
//
//  Created by Patrick Goley on 1/21/17.
//
//

import Foundation


indirect enum Expression {
    
    case number(Double)
    case variable(String)
    case call(String, [Expression])
    case binary(Expression, BinaryOperator, Expression)
}

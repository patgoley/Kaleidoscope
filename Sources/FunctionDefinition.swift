//
//  Function.swift
//  Kaleidoscope
//
//  Created by Patrick Goley on 1/21/17.
//
//

import Foundation


struct Prototype {
    
    let name: String
    
    let params: [String]
}


struct Definition {
    
    let prototype: Prototype
    
    let expression: Expression
}

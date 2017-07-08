//
//  UnicodeScalarExtensions.swift
//  Kaleidoscope
//
//  Created by Patrick Goley on 1/20/17.
//
//

import Foundation


extension UnicodeScalar {
    
    var isSpace: Bool {
        
        return isspace(Int32(self.value)) != 0
    }
    
    var isAlphanumeric: Bool {
        
        return isalnum(Int32(self.value)) != 0
    }
}

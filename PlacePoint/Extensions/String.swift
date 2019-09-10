//
//  File.swift
//  Clip the Deal
//
//  "" on 04/12/17.
//  Copyright © 2017 "". All rights reserved.
//
import UIKit

extension String {
    
    func trim() -> String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    //Validate Email
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}"
        
        let emailTest  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    
    //Valid Password Check
    func isValidPassword() -> Bool {
        
        let nameReg = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameReg)
        
        return nameTest.evaluate(with: self)
    }
}

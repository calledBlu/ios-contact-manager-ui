//
//  RegularExpression.swift
//  ContactManager
//
//  Created by Jason on 2022/12/23.
//

import Foundation

enum RegularExpression: String, CustomStringConvertible, CaseIterable {
    case namePattern = "^[A-Za-z]{1,}$"
    case agePattern = "^[0-999]{1,3}$"
    case phoneNumberPattern = "^0([0-9]{1,2})-([0-9]{3,4})-([0-9]{4})*$"
    
    var description: String {
        return self.rawValue
    }
}

//
//  Checker.swift
//  ContactManager
//
//  Created by 김보미 on 2022/12/23.
//

import Foundation

class Checker {
    func checkCorrectInput(target: [String]) -> [Bool] {
        var checkResult = [Bool]()

        for (inputText, pattern) in zip(target, RegularExpression.allCases) {
            let isCorrectInput = inputText.range(of: pattern.rawValue, options: .regularExpression) != nil
            checkResult.append(isCorrectInput)
        }

        return checkResult
    }

    func checkCorrectWord(target: [String]) -> ContactInformation? {
        var nameValue: String = ""
        var ageValue: String = ""
        var phoneNumberValue: String = ""
        
        target.indices.forEach {
            switch $0 {
            case 0:
                let isCorrectName = target[$0].range(of: RegularExpression.namePattern.rawValue, options: .regularExpression) != nil
                if isCorrectName == true {
                    nameValue = target[0]          // 값 지정
                } else {
                    print(PrintMessage.invalidName)
                }
                break
            case 1:
                let isCorrectAge = target[$0].range(of: RegularExpression.agePattern.rawValue, options: .regularExpression) != nil
                if isCorrectAge == true {
                    ageValue = target[1]
                } else {
                    print(PrintMessage.invalidAge)
                }
                break
            case 2:
                let isCorrectPhoneNumber = target[$0].range(of: RegularExpression.phoneNumberPattern.rawValue, options: .regularExpression) != nil
                if isCorrectPhoneNumber == true {
                    phoneNumberValue = target[2]
                } else {
                    print(PrintMessage.invalidPhoneNumber)
                }
                break
            default:
                return
            }
        }
        
        guard nameValue != "" && ageValue != "" && phoneNumberValue != "" else {
            return nil
        }
        
        return ContactInformation(name: nameValue, age: ageValue, phoneNumber: phoneNumberValue)
    }
}

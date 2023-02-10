//
//  AddNewContactViewController.swift
//  ContactManagerUI
//
//  Created by Blu on 2023/02/07.
//

import UIKit

class AddNewContactViewController: UIViewController {
    //MARK: - Property
    @IBOutlet var userInputData: [UITextField]!
    private var newContactData = [String]()
    private let contactManager = ContactManager()

    weak var delegate: SendContactDataDelegate?
    
    //MARK: - BarButtonAction
    @IBAction func tappedCancelButton(_ sender: UIBarButtonItem) {
        cancelConfirmAlert()
    }

    @IBAction func tappedSaveButton(_ sender: UIBarButtonItem) {
        let errorMessage = decideErrorMessage()

        if errorMessage.isEmpty {
            let sendingContactData = ContactInformation(name: newContactData[0], age: newContactData[1], phoneNumber: newContactData[2])

            contactManager.contactInformationArray.insert(sendingContactData)
            delegate?.updateTableView()
            
            dismiss(animated: true)
            return
        }
        successAlert(message: errorMessage)
    }
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        excludePhoneNumberTextField()
    }
    
    //MARK: - Method
    private func excludePhoneNumberTextField() {
        guard let phoneNumberTextField = userInputData.last else { return }
        phoneNumberTextField.delegate = self
    }
    
    private func decideErrorMessage() -> String {
        var returnMessage = ""
        let convertedUserInputData = renderToStringArray()
        newContactData = removeBlank(convertedUserInputData)
        let checkUserInput = contactManager.checker.checkCorrect(targets: newContactData)
        
        for (index, boolean) in checkUserInput.enumerated() {
            if !boolean {
                returnMessage = InputErrorMessage.allCases[index].rawValue
                break
            }
        }
        return returnMessage
    }
    
    private func renderToStringArray() -> [String] {
        var convertedData = [String]()
        
        userInputData.forEach { element in
            if let userInput = element.text {
                convertedData.append(userInput)
            }
        }
        return convertedData
    }

    private func removeBlank(_ inputData: [String]) -> [String] {
        var result = inputData
        if let removedBlankInputName = result.first {
            let joinedName = contactManager.removeBlankInput(value: removedBlankInputName)
            result[result.startIndex] = joinedName
        }
        return result
    }
}

//MARK: - TextFieldDelegate
extension AddNewContactViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text,
              let formattedPhoneNumber = formattingPhoneNumber(with: text) else { return }
        textField.text = formattedPhoneNumber
    }

    func formattingPhoneNumber(with number: String?) -> String? {
        guard let number = number else { return nil }

        let numberWithoutHyphen = number.split(separator: "-").joined()
        var phoneNumber = numberWithoutHyphen.map { String($0) }

        switch phoneNumber.count {
        case 0..<3:
            return phoneNumber.joined()
        case 3..<6:
            phoneNumber.insert("-", at: 2)
            return phoneNumber.joined()
        case 6..<10:
            phoneNumber.insert("-", at: 2)
            phoneNumber.insert("-", at: 6)
            return phoneNumber.joined()
        default:
            phoneNumber.insert("-", at: 3)
            phoneNumber.insert("-", at: 8)
            return phoneNumber.joined()
        }
    }
}

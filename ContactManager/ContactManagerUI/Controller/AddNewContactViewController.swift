//
//  AddNewContactViewController.swift
//  ContactManagerUI
//
//  Created by Blu on 2023/02/07.
//

import UIKit

class AddNewContactViewController: UIViewController {

    @IBOutlet var userInputTextArray: [UITextField]!
    private let contactManager = ContactManager()

    @IBAction func tappedCancelButton(_ sender: UIBarButtonItem) {
        failiureAlert()
    }

    @IBAction func tappedSaveButton(_ sender: UIBarButtonItem) {
        guard let check = checkUserInput() else { return }
        var alertIndex: Int?

        for (index, element) in check.enumerated() {
            if element == false {
                print("\(index)")
                alertIndex = index
                break
            }
        }
        
        switch alertIndex {
        case 0:
            successAlert(message: PrintMessage.invalidName.rawValue)
        case 1:
            successAlert(message: PrintMessage.invalidAge.rawValue)
        case 2:
            successAlert(message: PrintMessage.invalidPhoneNumber.rawValue)
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AddNewContactViewController {
    private func successAlert(message: String) {
        let success = UIAlertAction(title: "확인", style: .default, handler: nil)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(success)
        present(alert, animated: true, completion: nil)
    }
    
    private func failiureAlert() {
        let alert = UIAlertController(title: nil, message: "정말로 취소하시겠습니까?", preferredStyle: .alert)
        let allowAction = UIAlertAction(title: "예", style: .destructive, handler: { action in
            self.dismiss(animated: true)
        })
        let cancleAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(allowAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }

    private func checkUserInput() -> [Bool]? {
        var tempArray = [String]()

        for i in 0..<3 {
            guard var temp = self.userInputTextArray[i].text else { return nil }
            temp = removeBlankInput(name: temp)
            tempArray.append(temp)
        }
        return contactManager.checker.checkCorrectInput(target: tempArray)
    }

    private func removeBlankInput(name: String) -> String {
        let convertedInputName = contactManager.convertor.convertToCharacter(this: name)
        let removedBlankInputName = contactManager.detector.excludeSpaceWord(convertedInputName)
        let combinedInputName = contactManager.convertor.convertToString(removedBlankInputName)

        return combinedInputName
    }

    private func checkInputbyRegularExpression() {

    }
}

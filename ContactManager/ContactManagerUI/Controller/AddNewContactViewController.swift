//
//  AddNewContactViewController.swift
//  ContactManagerUI
//
//  Created by Blu on 2023/02/01.
//

import UIKit

class AddNewContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func tappedCancelButton(_ sender: UIBarButtonItem) {
        showAlert(message: "정말로 취소하시겠습니까?", handler: "아니오", "예")
    }

    @IBAction func tappedSaveButton(_ sender: UIBarButtonItem) {
//        showAlert(message: "입력한 이름 정보가 잘못되었습니다", handler: "확인")
//        showAlert(message: "입력한 나이 정보가 잘못되었습니다", handler: "확인")
        showAlert(message: "입력한 연락처 정보가 잘못되었습니다", handler: "확인")
    }

    private func showAlert(message: String, handler: String...) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)

        handler.enumerated().forEach {
            let button = UIAlertAction(title: $1, style: $0 == 1 ? .destructive : .default)
            alert.addAction(button)
        }

        present(alert, animated: true, completion: nil)
    }
}

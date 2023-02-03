//
//  ContactManagerTableViewController.swift
//  ContactManagerUI
//
//  Created by Blu on 2023/01/31.
//

import UIKit

var contactInfomation = [String: Any]()
var nameArray = [String]()
var ageArray = [String]()
var phoneNumberArray = [String]()

final class ContactManagerTableViewController: UITableViewController {

    @IBOutlet private weak var contactManagerTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        parseJSON()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func parseJSON() {
        guard let filePath = Bundle.main.url(forResource: "Dummy", withExtension: "json") else { return }
        
        if let data = try? Data(contentsOf: filePath) {
            let json =  try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            contactInfomation = json
        }
        
        if let contactInfo = contactInfomation["Dummy"] as? [[String: Any]] {
            contactInfo.forEach { contactData in
                nameArray.append(contactData["name"] as! String)
                ageArray.append(contactData["age"] as! String)
                phoneNumberArray.append(contactData["phoneNumber"] as! String)
            }
        }
    }

    @IBAction func tappedAddNewContactButton(_ sender: UIBarButtonItem) {
        guard let nextViewController = self.storyboard?.instantiateViewController(identifier: "AddNewContactViewController") as? AddNewContactViewController else { return }

        nextViewController.modalTransitionStyle = .coverVertical
        // modalPresentationStyle이 automatic인 경우 창이 겹쳐보이는 형태로 나오고
        // fullScreen으로 하는 경우 전체화면으로 보이게끔 나타남!
        nextViewController.modalPresentationStyle = .automatic

        present(nextViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "infoCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)

        // currnent state를 활용해서 configuration을 update해주는 블록
        cell.configurationUpdateHandler = { cell, state in
            var infoContent = cell.defaultContentConfiguration().updated(for: state)
            infoContent.text = "\(nameArray[indexPath.row])(\(ageArray[indexPath.row]))"
            infoContent.secondaryText = phoneNumberArray[indexPath.row]

            cell.accessoryType = .disclosureIndicator
            cell.contentConfiguration = infoContent
        }
        return cell
    }
}

protocol ReusableTableViewCell {
    static var reuseIdentifier: String { get }
}

extension ReusableTableViewCell {
    // 기존의 withIdentifier가 String으로 전달되기 때문에 string 타입을 반환하는 연산 프로퍼티 선언
    static var reuseIdentifier: String {
        // 제네릭 타입은 빌드 시점에서 평가되므로 UITableViewCell이 self에 들어가고
        // "UITableViewCell"이라는 String이 return
        String(describing: self)
    }
}

extension UITableViewCell: ReusableTableViewCell {}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable Dequeue Reuseable")
        }
        return cell
    }
}

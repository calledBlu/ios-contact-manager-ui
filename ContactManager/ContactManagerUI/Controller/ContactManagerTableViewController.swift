//
//  ContactManagerTableViewController.swift
//  ContactManagerUI
//
//  Created by Blu on 2023/01/31.
//

import UIKit

final class ContactManagerTableViewController: UITableViewController {
    
    //MARK: - Property
    @IBOutlet private weak var contactManagerTableView: UITableView!
    private var contactInfomation = [ContactInformation]()
    private var jsonManagement: JSONParsable = JSONManangement()
    
    //MARK: - BarButtonAction
    @IBAction func tappedAddNewContactAction(_ sender: UIBarButtonItem) {
        guard let addNewContactVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewContactViewController") as? AddNewContactViewController else { return }

        addNewContactVC.modalTransitionStyle = .coverVertical
        addNewContactVC.modalPresentationStyle = .automatic

        addNewContactVC.delegate = self
        
        present(addNewContactVC, animated: true)
    }
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        assignJSONData()
    }

    //MARK: - Method
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func assignJSONData() {
        guard let parsedInformation = jsonManagement.parseJSON() else { return }
        contactInfomation = parsedInformation
    }
}

extension ContactManagerTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfomation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellClass: UITableViewCell.self, for: indexPath)
        
        cell.configurationUpdateHandler = { cell, state in
            var infoContent = cell.defaultContentConfiguration().updated(for: state)
            infoContent.text = "\(self.contactInfomation[indexPath.row].name)(\(self.contactInfomation[indexPath.row].age))"
            infoContent.secondaryText = self.contactInfomation[indexPath.row].phoneNumber
            
            cell.accessoryType = .disclosureIndicator
            cell.contentConfiguration = infoContent
        }
        return cell
    }
}

extension ContactManagerTableViewController: SendContactDataDelegate {
    func sendData(newData: ContactInformation) {
        contactInfomation.append(newData)
        contactManagerTableView.reloadData()
    }
    
    func updateModel() {
        contactManagerTableView.reloadData()
    }
}

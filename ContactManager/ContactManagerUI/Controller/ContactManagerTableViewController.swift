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
    
    //MARK: - BarButtonAction
    @IBAction func tappedAddNewContactAction(_ sender: UIBarButtonItem) {
        guard let addContactVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewContactViewController") as? AddNewContactViewController else { return }

        addContactVC.modalTransitionStyle = .coverVertical
        addContactVC.modalPresentationStyle = .automatic

        addContactVC.delegate = self
        
        present(addContactVC, animated: true)
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
    
    private func loadJSON<T: Decodable>(_ filename: String) throws -> T {
        let data: Data
        
        guard let filePath = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("\(filename) not found.")
            throw Errors.notFoundJSONFile
        }
        
        do {
            data = try Data(contentsOf: filePath)
        } catch {
            print("Could not load \(filename): (error)")
            throw Errors.notLoadData
        }
        
        do {
            let JSONDecoder = JSONDecoder()
            return try JSONDecoder.decode(T.self, from: data)
        } catch {
            print("Unable to decode \(filename): (error)")
            throw Errors.unableToDecode
        }
    }

    private func parseJSON() -> [ContactInformation]? {
        guard let parsedInformation: [ContactInformation] = try? loadJSON("Dummy.json") else {
            return nil
        }
        return parsedInformation
    }
    
    private func assignJSONData() {
        guard let parsedInformation = parseJSON() else { return }
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
}

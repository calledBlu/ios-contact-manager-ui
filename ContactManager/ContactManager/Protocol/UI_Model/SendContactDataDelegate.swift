//
//  SendContactDataDelegate.swift
//  ContactManager
//
//  Created by Jason on 2023/02/08.
//

import Foundation

protocol SendContactDataDelegate: AnyObject {
    func sendData(newData: ContactInformation)
    func updateModel()
}

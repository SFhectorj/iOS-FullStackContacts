//
//  Contact.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 7/12/25.
//
import Foundation

class Contact: Codable {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var isEmergency: Bool = false
    
    var fullName: String{
        return "\(firstName) \(lastName)"
    }
    
    init(firstName:String, lastName:String, phoneNumber:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}


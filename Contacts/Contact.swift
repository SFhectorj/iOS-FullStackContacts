//
//  Contact.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 7/12/25.
//
import Foundation

class Contact: Codable, Equatable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var isEmergency: Bool = false
    
    var fullName: String{
        return "\(firstName) \(lastName)"
    }
    
    init(id: UUID = UUID(), firstName: String, lastName: String, phoneNumber: String, isEmergency: Bool = false) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.isEmergency = isEmergency
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}


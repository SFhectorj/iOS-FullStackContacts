//
//  EditProfileViewController.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 8/3/25.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var profile: Contact?
    var onSaveProfile: ((Contact) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit My Profile"
        
        // Pre-fill fields if profile exists
        if let profile = profile {
            firstNameTextField.text = profile.firstName
            lastNameTextField.text = profile.lastName
            phoneNumberTextField.text = profile.phoneNumber
        }
    }

    @IBAction func saveProfileTapped(_ sender: UIButton) {
        guard let first = firstNameTextField.text,
              let last = lastNameTextField.text,
              let phone = phoneNumberTextField.text,
              !first.isEmpty, !last.isEmpty, !phone.isEmpty else { return }
        
        let updatedProfile = Contact(
            id: profile?.id ?? UUID(),
            firstName: first,
            lastName: last,
            phoneNumber: phone
        )
        
        onSaveProfile?(updatedProfile)
        navigationController?.popViewController(animated: true)
    }
}

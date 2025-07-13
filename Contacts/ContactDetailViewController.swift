//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 7/21/25.
//

import UIKit

class ContactDetailViewController: UIViewController {
    var contact: Contact?
    var onDelete: (() -> Void)?
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emergencyContactSwitch: UISwitch!
    
    func deleteContact() {
        onDelete?()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Contact"
        
        if let contact = contact {
            firstNameTextField.text = contact.firstName
            lastNameTextField.text = contact.lastName
            phoneNumberTextField.text = contact.phoneNumber
            emergencyContactSwitch.isOn = contact.isEmergency
            emergencyContactSwitch.addTarget(self, action: #selector(emergencySwitchToggled(_:)), for: .valueChanged)
        }
    }

    // Handles UISwitch for emergency contact
    @objc func emergencySwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            // Clear emergency flag from all other contacts
            if let navigationController = navigationController {
                let viewControllers = navigationController.viewControllers
                if let mainVC = viewControllers.first(where: { $0 is ViewController }) as? ViewController {
                    for existingContact in mainVC.contacts {
                        existingContact.isEmergency = false
                    }
                    contact?.isEmergency = true
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let contact = contact else { return }
        
        contact.firstName = firstNameTextField.text ?? ""
        contact.lastName = lastNameTextField.text ?? ""
        contact.phoneNumber = phoneNumberTextField.text ?? ""
        contact.isEmergency = emergencyContactSwitch.isOn
        
        navigationController?.popViewController(animated: true)
    }
    
    // Delete Contact Button
    @IBAction func deleteContactTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Delete Contact",
            message: "Are you sure you want to delete this contact?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteContact()
        })

        present(alert, animated: true)
    }
}

//
//  SignUpViewController.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 8/31/25.
//
import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var outerFormBorder: UIView!
    
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        //Style outer border
        outerFormBorder.layer.cornerRadius = 13
        
        
        title = "Sign Up"
        
        //Initial button state
        registerButton.isEnabled = false
        registerButton.backgroundColor = .systemGray4
        registerButton.layer.cornerRadius = 8
        
        // Monitor text fields
        [firstNameField, lastNameField, emailField, dobField, phoneField, passwordField].forEach {
            $0?.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        }
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        dobField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didSelectDate))
        ]
        dobField.inputAccessoryView = toolbar
    }
    
    @objc private func didSelectDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dobField.text = formatter.string(from: datePicker.date)
        dobField.resignFirstResponder()
        textFieldsChanged()
    }
    
    @objc func textFieldsChanged() {
        let isFormFilled = !(firstNameField.text?.isEmpty ?? true) &&
                           !(lastNameField.text?.isEmpty ?? true) &&
                           !(emailField.text?.isEmpty ?? true) &&
                           !(dobField.text?.isEmpty ?? true) &&
                           !(phoneField.text?.isEmpty ?? true) &&
                           !(passwordField.text?.isEmpty ?? true)
        
        registerButton.isEnabled = isFormFilled
        registerButton.backgroundColor = isFormFilled ? .systemGreen : .systemGray4
        registerButton.titleLabel?.textColor = isFormFilled ? .white : .label
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? ViewController else {
            return
        }
        
        let navController = UINavigationController(rootViewController: mainVC)
        sceneDelegate.window?.rootViewController = navController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}

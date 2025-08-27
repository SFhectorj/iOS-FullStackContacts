//
//  LoginFormViewController.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 8/26/25.
//
import UIKit

class LoginFormViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        // Initially disable login button
        loginButton.isEnabled = false
        loginButton.backgroundColor = .systemGray4
        loginButton.layer.cornerRadius = 8
        
        // Monitor text fields
        emailTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
    }
    
    @objc func textFieldsChanged() {
        let isFormFilled = !(emailTextField.text?.isEmpty ?? true) &&
                           !(passwordTextField.text?.isEmpty ?? true)
        
        loginButton.isEnabled = isFormFilled
        loginButton.backgroundColor = isFormFilled ? .systemGreen : .systemGray4
        loginButton.titleLabel?.textColor = isFormFilled ? .white : .label
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? ViewController else {
            return
        }
        
        // Wrap MainViewController in a Navigation Controller
        let navController = UINavigationController(rootViewController: mainVC)
        navController.modalPresentationStyle = .fullScreen
        
        // Replace rootViewController with the navController
        // Resets navigation stack
        sceneDelegate.window?.rootViewController = navController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}

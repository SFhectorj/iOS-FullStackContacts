//
//  LoginViewController.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 8/16/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style buttons
        //signUpButton.setTitleColor(.systemBlue, for: .normal)
        //loginButton.setTitleColor(.white, for: .normal)
        //loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 8
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        // For now: do nothing
        print("Sign Up tapped")
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if let formVC = storyboard?.instantiateViewController(withIdentifier: "LoginFormViewController") as? LoginFormViewController {
            navigationController?.pushViewController(formVC, animated: true)
        }
    }
    
    @objc func logoutTapped() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        
        sceneDelegate.window?.rootViewController = loginVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
}

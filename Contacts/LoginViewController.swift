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
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 8
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 8
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if let formVC = storyboard?.instantiateViewController(withIdentifier: "LoginFormViewController") as? LoginFormViewController {
            navigationController?.pushViewController(formVC, animated: true)
        }
    }
    
    @objc func logoutTapped() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        
        let navController = UINavigationController(rootViewController: loginVC)
        sceneDelegate.window?.rootViewController = navController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}

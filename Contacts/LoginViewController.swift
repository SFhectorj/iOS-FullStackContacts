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
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? ViewController else {
            return
        }
        
        // Wrap MainViewController in a Navigation Controller
        let navController = UINavigationController(rootViewController: mainVC)
        
        // Make it the new root
        sceneDelegate.window?.rootViewController = navController
        sceneDelegate.window?.makeKeyAndVisible()
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

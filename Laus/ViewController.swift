//
//  ViewController.swift
//  Laus
//
//  Created by Lord Summerisle on 10/7/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseCore

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.delegate = self
        view.addSubview(facebookLoginButton)
        
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        facebookLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Succesfully logged in")
    }
    
}


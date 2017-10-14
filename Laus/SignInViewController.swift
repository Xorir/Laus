//
//  ViewController.swift
//  Laus
//
//  Created by Lord Summerisle on 10/7/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseCore
import Firebase

class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    private struct Constants {
        static let padding: CGFloat = 16.0
        static let topConstant: CGFloat = 10.0
        static let httpMethod = "GET"
        static let email = "email"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.delegate = self
        view.addSubview(facebookLoginButton)
        
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        facebookLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: Constants.topConstant).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard let authenticationToken = FBSDKAccessToken.current().tokenString else { return }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: (authenticationToken))
        let emailAddress = getUserEmail(authToken: authenticationToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { [weak self] (user, error) in
            guard let strongSelf = self else { return }
            
            if error != nil {
                return
            }
            strongSelf.signedIn(user, email: emailAddress)
        })
    }
    
    func getUserEmail(authToken: String) -> String {
        var resultDictionary = NSDictionary()
        let parameters = ["fields" : "email, name"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: parameters, tokenString: authToken, version: nil, httpMethod: Constants.httpMethod)
        graphRequest?.start(completionHandler: { (connection, result, error) in
            if error != nil {
                return
            }
            resultDictionary = result as! NSDictionary
        })
        
        if let emailAddress = resultDictionary[Constants.email] {
            return emailAddress as! String
        }
        return "Unknown"
    }
    
    func signedIn(_ user: FIRUser?, email: String? = nil) {
        AppState.sharedInstance.displayName = user?.displayName ?? email
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.UID = user?.uid
        presentMainViewCOntroller()
    }
    
    func presentMainViewCOntroller() {
        let mainViewController = MainViewController()
        mainViewController.title = "Darn Main"
        self.present(mainViewController, animated: true, completion: nil)
    }
}


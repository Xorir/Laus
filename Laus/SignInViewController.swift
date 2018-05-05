//
//  ViewController.swift
//  Laus
//
//  Created by Lord Summerisle on 10/7/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import FirebaseCore
import Firebase

class SignInViewController: UIViewController {
    private struct Constants {
        static let padding: CGFloat = 16.0
        static let topConstant: CGFloat = 10.0
        static let httpMethod = "GET"
        static let email = "email"
        static let graphPath = "me"
        static let fields = "fields"
        static let mainViewController = "Main View"
        static let lausMainStoryboard = "LausMainStoryboard"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(signOutFireBaseUser), name: NSNotification.Name("signOutFireBaseUser"), object: nil)
        
        setFacebookLoginButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAuthentication()
    }
    
    func setFacebookLoginButton() {
        let facebookLoginButton = LoginButton(readPermissions: [.publicProfile])
        view.addSubview(facebookLoginButton)
        
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        facebookLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: Constants.topConstant).isActive = true
    }
    
    func checkAuthentication() {
        //Facebook authentication
        if let authenticationToken = FBSDKAccessToken.current() {
            let credential = FacebookAuthProvider.credential(withAccessToken: (authenticationToken.tokenString))
            let emailAddress = getUserEmail(authToken: authenticationToken.description)
            
            //Firebase authentication
            Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
                guard let strongSelf = self else { return }
                
                if error != nil { return }
                strongSelf.signedIn(user, email: emailAddress)
            })
        }
    }
    
    func signOutFireBaseUser() {
        let loginManager = LoginManager()
        loginManager.logOut()
        do {
            try Auth.auth().signOut()
        } catch {
            print("log out error")
        }
    }
    
    func getUserEmail(authToken: String) -> String {
        var resultDictionary = NSDictionary()
        let parameters = [Constants.fields : "email, name"]
        let graphRequest = FBSDKGraphRequest(graphPath: Constants.graphPath, parameters: parameters, tokenString: authToken, version: nil, httpMethod: Constants.httpMethod)
        graphRequest?.start(completionHandler: { (connection, result, error) in
            if error != nil {  return }
            resultDictionary = result as! NSDictionary
        })
        
        if let emailAddress = resultDictionary[Constants.email] {
            return emailAddress as! String
        }
        return "Unknown"
    }
    
    func signedIn(_ user: User?, email: String? = nil) {
        AppState.sharedInstance.displayName = user?.displayName ?? email
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.UID = user?.uid
        presentMainViewController()
    }
    
    func presentMainViewController() {
//                let mainViewController = MainViewController()
//                let navigationController = UINavigationController(rootViewController: mainViewController)
//                mainViewController.title = Constants.mainViewController
//                mainViewController.delegate = self
//                self.present(navigationController, animated: true, completion: nil)
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: Constants.lausMainStoryboard, bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


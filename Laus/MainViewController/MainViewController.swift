//
//  MainViewController.swift
//  Laus
//
//  Created by Lord Summerisle on 10/14/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseCore
import Firebase

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        title = "darn"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserLocationManager.sharedInstance.getUserLocation()
    }
    
    func dismissViewController() {
        self.dismiss(animated: true) { }
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name("signOutFireBaseUser"), object: nil)
    }
}

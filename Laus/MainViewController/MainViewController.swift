//
//  MainViewController.swift
//  Laus
//
//  Created by Lord Summerisle on 10/14/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
    }
    
    func dismissViewController() {
        self.dismiss(animated: true) { 
            
        }
    }
    
}

//
//  LogInViewController.swift
//  iMessage
//
//  Created by Edward on 7/23/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(CreateRoomViewController.dismissKeyboard(_:)))
        dismissKeyboard.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboard)
    }
    func dismissKeyboard(tap: UITapGestureRecognizer){
        view.endEditing(true)
    }

    @IBAction func loginDidTapped(sender: AnyObject) {
        guard let email = emailTxtField.text where !email.isEmpty, let password = passwordTxtField.text where !password.isEmpty else{
            ProgressHUD.showError("Email and Password cant be empty")
            return
        }
        ProgressHUD.show("Signing in...")
        DataService.dataService.login(email, password: password)
    }
}

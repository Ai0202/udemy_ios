//
//  ViewController.swift
//  swiftKeyBoard
//
//  Created by Atsushi on 2018/05/14.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @IBAction func signIn(_ sender: Any) {
        resultLabel.text = mailTextField.text! + " " + passwordTextField.text!
    }
    
}


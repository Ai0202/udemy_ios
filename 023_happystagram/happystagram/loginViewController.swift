//
//  loginViewController.swift
//  happystagram
//
//  Created by Atsushi on 2018/05/31.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func createNewUser(_ sender: Any) {
        
        if mailTextField.text == nil || passwordTextField.text == nil {
            
            let alertController = UIAlertController(title: "ちょ", message: "空欄だよ!!!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: mailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                if error == nil{
                    
                }else{
                    
                    //失敗
                    let alertController = UIAlertController(title: "おっと", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            })
        }
    }
    
    @IBAction func userLogin(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: mailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            if error == nil{
                
                UserDefaults.standard.set("check", forKey: "check")
                
                self.dismiss(animated: true, completion: nil)
                
            }else{
                //失敗
                let alertController = UIAlertController(title: "おっと", message: error?.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
        
    }
    
    

}

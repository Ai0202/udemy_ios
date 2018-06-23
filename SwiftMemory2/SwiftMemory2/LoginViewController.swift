//
//  LoginViewController.swift
//  SwiftMemory2
//
//  Created by Atsushi on 2018/06/21.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreLocation


class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,CLLocationManagerDelegate  {
    
    var profileImage:URL!
    var locationManager:CLLocationManager!
    var fullName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 20, y: 250, width: self.view.frame.size.width-40, height: 60)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("エラーです。",err)
            return
        }
        print("成功しました！")
        fullName = user.profile.name
        UserDefaults.standard.set(0, forKey: "login")
        guard let idToken = user.authentication.idToken else {
            return
        }
        guard let accessToken = user.authentication.accessToken else{
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credential, completion: { (user,error) in
            if let err = error{
                print("エラー",err)
                return
            }
            let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 100)
            self.profileImage = imageUrl
            self.performSegue(withIdentifier: "first", sender: nil)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let uid = Auth.auth().currentUser?.uid
        let viewController = segue.destination as! ViewController
        viewController.uid = uid
        viewController.profileImage = self.profileImage! as URL
        viewController.fullName = self.fullName
    }
        
}

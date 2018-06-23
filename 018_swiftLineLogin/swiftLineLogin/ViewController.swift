//
//  ViewController.swift
//  swiftLineLogin
//
//  Created by Atsushi on 2018/05/27.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import LineSDK

class ViewController: UIViewController, LineSDKLoginDelegate {
    
    var displayName = String()
    var statusMessage = String()
    var pictureUrlString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LineSDKLogin.sharedInstance().delegate = self
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        LineSDKLogin.sharedInstance().start()
    }
    
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        // 表示名
        if let displayName = profile?.displayName {
            print("displayName : \(displayName)")
            
            self.displayName = displayName
        }
        
        //ステータスメッセージ
        if let statusMessage = profile?.statusMessage{
            
            self.statusMessage = statusMessage
        }
        
        // プロフィール写真のURL
        if let pictureURL = profile?.pictureURL {
            self.pictureUrlString = pictureURL.absoluteString
            print(self.pictureUrlString)
        }
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileVC = segue.destination as! ProfileViewController
        
        profileVC.displayName = self.displayName
        profileVC.statusMessage = self.statusMessage
        profileVC.pictureUrlString = self.pictureUrlString
        
    }

}


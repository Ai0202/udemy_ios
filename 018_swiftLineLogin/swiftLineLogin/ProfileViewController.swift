//
//  profileViewController.swift
//  swiftLineLogin
//
//  Created by Atsushi on 2018/05/27.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import LineSDK
import SDWebImage

class ProfileViewController: UIViewController {
    
    var displayName = String()
    var statusMessage = String()
    var pictureUrlString = String()
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabel.text = displayName
        imageView.sd_setImage(with: URL(string: pictureUrlString))
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        
        textView.text = statusMessage
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let apiClient = LineSDKAPI(configuration: LineSDKConfiguration.defaultConfig())
        
        apiClient.logout(queue: .main) { (success, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

//
//  ViewController.swift
//  swiftMagic4
//
//  Created by Atsushi on 2018/05/23.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var bodyField: UITextField!
    
    var timerNotificationIdentifier = "id1"
    
    var resultString = ""
    var bond = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        bodyField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resultString = nameField.text! + bond + bodyField.text!
        
//        キーボードを閉じる
        textField.becomeFirstResponder()
        
        return true
    }
    
    func startPush() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            if(settings.authorizationStatus == .authorized) {
                self.push()
            }else{
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: ({ (granted, error) in
                    if let error = error {
                        print(error)
                    }else{
                        if(granted) {
                            self.push()
                        }
                    }
                }))
            }
        }
        
        
    }
    
    func push() {
        
        let content = UNMutableNotificationContent()
        content.title = nameField.text!
        content.subtitle = bodyField.text!
        
        let timerIconURL = Bundle.main.url(forResource: "sunrise", withExtension: "jpg")
        let attach = try! UNNotificationAttachment(identifier: timerNotificationIdentifier, url: timerIconURL!, options: nil)
        
        content.attachments.append(attach)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: "timerNotificationIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print(error)
            } else {
                print("配信されました")
            }
        }
    }
    
    @IBAction func tap(_ sender: Any) {
        
        startPush()
    }

}


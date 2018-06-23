//
//  EditViewController.swift
//  happystagram
//
//  Created by Atsushi on 2018/06/02.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UITextViewDelegate {

    var willEditImage:UIImage = UIImage()
    
    @IBOutlet weak var myProfileImage: UIImageView!
    
    @IBOutlet weak var myProfileLabel: UILabel!
    
    @IBOutlet weak var commentText: UITextView!
    
    @IBOutlet weak var image: UIImageView!
    
    var usernameString:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = willEditImage
        commentText.delegate = self
        myProfileImage.layer.cornerRadius = 8.0
        myProfileImage.clipsToBounds = true
        
        if UserDefaults.standard.object(forKey: "profileImage") != nil{
            
            //エンコードして取り出す
            let decodeData = UserDefaults.standard.object(forKey: "profileImage")
            let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            
            let decodedImage = UIImage(data: decodedData! as Data)
            myProfileImage.image = decodedImage
            
            usernameString = UserDefaults.standard.object(forKey: "username") as! String
            
            myProfileLabel.text = usernameString
        }else{
            myProfileImage.image = UIImage(named: "logo.png")
            myProfileLabel.text = "匿名"
        }

    }
    
    
    @IBAction func post(_ sender: Any) {
        
    }
    
    func postAll(){
        let databaseRef = Database.database().reference()
        
        //ユーザー名
        let username = myProfileLabel.text!
        
        //コメント
        let message = commentText.text!
        
        //投稿画像
        var data:NSData = NSData()
        if let image = image.image{
            data = UIImageJPEGRepresentation(image, 0.1)! as
            NSData
        }
        let base64String = data.base64EncodedString(options:NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        //profile画像
        var data2:NSData = NSData()
        if let image2 = image.image{
            data2 = UIImageJPEGRepresentation(image2, 0.1)! as NSData
        }
        let base64String2 = data2.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        //サーバーに飛ばすはこ
        let user:NSDictionary = ["username":username, "comment":message,
                                 "profileImage":base64String, "postImage":base64String2]
        
        databaseRef.child("posts").childByAutoId().setValue(user)
        
        //戻る
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

//
//  EditViewController.swift
//  SwiftMemory2
//
//  Created by Atsushi on 2018/06/22.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var myProfileImageView: UIImageView!
    @IBOutlet var myProfileLabel: UILabel!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    var fullName = String()
    var uid = Auth.auth().currentUser?.uid
    var address = String()
    var profileImage:URL!
    var passImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.delegate = self
        myProfileImageView.layer.cornerRadius = 8.0
        myProfileImageView.clipsToBounds = true
        imageView.image = passImage
        myProfileLabel.text = fullName
        let url = URL(string: self.profileImage.absoluteString)
        let imageData = NSData(contentsOf: url!)
        let img = UIImage(data:imageData! as Data)
        myProfileImageView.image = img
    }
    
    func postAll(){
        AppDelegate.instance().showIndicator()
        uid = Auth.auth().currentUser?.uid
        let rootRef = Database.database().reference(fromURL: "https://swiftmemory2-40069.firebaseio.com/").child("address").child(self.address)
        //ここに1つつくる
        let rootRef2 = Database.database().reference(fromURL: "https://swiftmemory2-40069.firebaseio.com/").child("AddressforPin")
        let storage = Storage.storage().reference(forURL: "gs://swiftmemory2-40069.appspot.com")
        let key = rootRef.child("Users").childByAutoId().key
        //ここに1つつくる
        let key2 = rootRef2.child("Address").childByAutoId().key
        let imageRef = storage.child("Users").child(uid!).child("\(key).jpg")
        //投稿画像
        var data:NSData = NSData()
        if let image = imageView.image{
            data = UIImageJPEGRepresentation(image,0.1)! as NSData
        }
        let uploadTask = imageRef.putData(data as Data, metadata: nil) { (metaData, error) in
            if error != nil {
                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if url != nil {
                    let urlString = try? String(contentsOf: url!)
                    //ここで一括でサーバーへ
                    let feed = ["userID":self.uid,"pathToImage":self.profileImage.absoluteString,"postID":key,"postImage":url?.absoluteString,"comment":self.commentTextView.text!,"address":self.address,"fullName":self.fullName] as [String:Any]
                    
                    //ここに1つつくる
                    let feed2 = ["addressforpin":self.address] as [String:Any]
                    //ここに1つつくる
                    let postFeed = ["\(key)":feed]
                    let postFeed2 = ["\(key2)":feed2]
                    rootRef.updateChildValues(postFeed)
                    rootRef2.updateChildValues(postFeed2)
                    AppDelegate.instance().dismissActivityIndicator()
                }})
        }
        uploadTask.resume()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postData(_ sender: Any) {
        postAll()
    }

}

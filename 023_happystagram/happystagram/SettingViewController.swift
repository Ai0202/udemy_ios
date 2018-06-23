//
//  SettingViewController.swift
//  happystagram
//
//  Created by Atsushi on 2018/06/02.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
    {

    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameText.delegate = self
    }
    
    
    @IBAction func changeProfile(_ sender: Any) {
        let alertController = UIAlertController(title: "選択してください", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction!) -> Void in
           
            self.openCamera()
            
        })
        
        let photoAction = UIAlertAction(title: "アルバム", style: .default, handler: {(action:UIAlertAction!) -> Void in
            
            self.openPhoto()
            
        })
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        
        UserDefaults.standard.removeObject(forKey: "check")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        var data:NSData = NSData()
        if let image = profileImage.image{
            
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        }
        
        let userName = usernameText.text
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
        UserDefaults.standard.set(base64String, forKey: "profileImage")
        UserDefaults.standard.set(base64String, forKey: "userName")
        dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func openPhoto() {
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .scaleToFill
            profileImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(usernameText.isFirstResponder){
            usernameText.resignFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}

//
//  ViewController.swift
//  swiftInstaCamera
//
//  Created by Atsushi on 2018/05/28.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func album(_ sender: Any) {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func camera(_ sender: Any) {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image.image = pickedImage

            performSegue(withIdentifier: "next",sender: nil)

        }

        picker.dismiss(animated: true, completion: nil)

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let editVC = segue.destination as! EditViewController
            
            editVC.willEditImage = image.image!
        }
    }


}


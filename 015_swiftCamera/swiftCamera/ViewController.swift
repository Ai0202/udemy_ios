//
//  ViewController.swift
//  swiftCamera
//
//  Created by Atsushi on 2018/05/24.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //アルバムの使用許可
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status) {
            case .authorized:
                print("authorized")
            
            case .denied:
                print("denied")
                
            case .notDetermined:
                print("notDetermined")
                
            case .restricted:
                print("restricted")
            }
        }
        
    }
    
    @IBAction func camera(_ sender: Any) {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func album(_ sender: Any) {
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    //写真を選択した後の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picker = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = picker
            
            //アルバムに写真を保存
            UIImageWriteToSavedPhotosAlbum(picker, self, nil, nil)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }


}


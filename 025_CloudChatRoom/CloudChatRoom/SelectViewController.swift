//
//  SelectViewController.swift
//  CloudChatRoom
//
//  Created by Atsushi on 2018/06/04.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SelectViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate,
    UINavigationBarDelegate, UINavigationControllerDelegate{

    var uid = Auth.auth().currentUser?.uid
    
    var profileImage:NSURL!
    
    var locationManager: CLLocationManager! = CLLocationManager()
    
    @IBOutlet weak var idoLabel: UILabel!
    
    @IBOutlet weak var keidoLabel: UILabel!
    
    var country:String = String()
    var administrativeArea:String = String()
    var subAdministrativeArea:String = String()
    var locality:String = String()
    var subLocality:String = String()
    var thoroughfare:String = String()
    var subThoroughfare:String = String()
    var address:String = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        catchLocationData()
    }
    
    func catchLocationData(){
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    
    /*******************************************
     
     //位置情報取得に関するアラートメソッド
     
     ********************************************/
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    /**********************************
     
     // 位置情報が更新されるたびに呼ばれるメソッド
     
     ***********************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        self.idoLabel.text = "".appendingFormat("%.4f", newLocation.coordinate.latitude)
        self.keidoLabel.text = "".appendingFormat("%.4f", newLocation.coordinate.longitude)
        self.reverseGeocode(latitude: Double(idoLabel.text!)!, longitude: Double(keidoLabel.text!)!)
        
    }
    
    // 逆ジオコーディング処理(緯度・経度を住所に変換)
    func reverseGeocode(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemark, error) -> Void in
            let placeMark = placemark?.first
            if let country = placeMark?.country {
                
                
                print("\(country)")
                
                self.country = country
            }
            if let administrativeArea = placeMark?.administrativeArea {
                print("\(administrativeArea)")
                
                self.administrativeArea = administrativeArea
            }
            if let subAdministrativeArea = placeMark?.subAdministrativeArea {
                print("\(subAdministrativeArea)")
                
                self.subAdministrativeArea = subAdministrativeArea
                
            }
            
            if let locality = placeMark?.locality {
                print("\(locality)")
                
                self.locality = locality
            }
            if let subLocality = placeMark?.subLocality {
                print("\(subLocality)")
                
                self.subLocality = subLocality
            }
            if let thoroughfare = placeMark?.thoroughfare {
                print("\(thoroughfare)")
                
                self.thoroughfare = thoroughfare
            }
            if let subThoroughfare = placeMark?.subThoroughfare {
                print("\(subThoroughfare)")
                
                self.subThoroughfare = subThoroughfare
            }
            
            self.address = self.country + self.administrativeArea + self.subAdministrativeArea
                + self.locality + self.subLocality
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createroom"{
            let createRoomVC = segue.destination as! CreateRoomViewController
            createRoomVC.uid = uid
            createRoomVC.profileImage = profileImage
        } else if segue.identifier == "roomsList"{
            let roomsVC = segue.destination as! RoomsViewController
            roomsVC.uid = uid
            roomsVC.profileImage = profileImage
            address = self.country + self.administrativeArea + self.subAdministrativeArea
                + self.locality + self.subLocality
            
            roomsVC.address = address
        }
    }
    
    @IBAction func goCreateRoomView(_ sender: Any) {
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
        }
        
        self.performSegue(withIdentifier: "createroom", sender: nil)
    }
    
    @IBAction func searchRooms(_ sender: Any) {
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
        }
        
        self.performSegue(withIdentifier: "roomsList", sender: nil)
    }
    
    @IBAction func backGroundphoto(_ sender: Any) {
        showAlertViewController()
    }
    
    
    
    func showAlertViewController(){
        
        let alertController = UIAlertController(title: "選択してください。", message: "チャットの背景画像を変更します。", preferredStyle: .actionSheet)
        
        let cameraButton:UIAlertAction = UIAlertAction(title: "カメラから", style: UIAlertActionStyle.default,handler: { (action:UIAlertAction!) in
            
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
            
        })

        let albumButton:UIAlertAction = UIAlertAction(title: "アルバムから", style: UIAlertActionStyle.default,handler: { (action:UIAlertAction!) in
            
            let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
            // カメラが利用可能かチェック
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                // インスタンスの作成
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
            }
        })
        
        let cancelButton:UIAlertAction = UIAlertAction(title: " キャンセル", style: UIAlertActionStyle.cancel,handler: { (action:UIAlertAction!) in
            //キャンセル
        })
        
        alertController.addAction(cameraButton)
        alertController.addAction(albumButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //Userdefaultsへ保存
            UserDefaults.standard.set(UIImagePNGRepresentation(pickedImage), forKey: "backGroundImage")
            
            
        }
        
        //カメラ画面(アルバム画面)を閉じる処理
        picker.dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

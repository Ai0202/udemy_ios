//
//  ViewController.swift
//  happystagram
//
//  Created by Atsushi on 2018/05/30.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

//FIXME googleログインでこける

import UIKit
import Firebase

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UINavigationControllerDelegate {

    var items = [NSDictionary]()

    let refreshControl = UIRefreshControl()
    
    var passImage:UIImage = UIImage()
    
    var nowtableViewImage = UIImage()
    var nowtableViewUserName = String()
    var nowtableViewUserImage = UIImage()
    
    @IBOutlet weak var tableView: UITableView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "check") != nil{
            
        }else{
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        items = [NSDictionary]()
        loadAllData()
        tableView.reloadData()
    }
    
    @objc func refresh(){
        items = [NSDictionary]()
        loadAllData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let dict = items[(indexPath as NSIndexPath).row]
        
        let profileImgView = cell.viewWithTag(1) as! UIImageView
        
        let decodeData = (base64Encoded:dict["profileImage"])
        let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data:decodedData! as Data)
        profileImgView.layer.cornerRadius = 8.0
        profileImgView.clipsToBounds = true
        profileImgView.image = decodedImage
        
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = dict["username"] as? String
        
        let postedImageView = cell.viewWithTag(3) as! UIImageView
        
        let decodeData2 = (base64Encoded:dict["postImage"])
        let decodedData2 = NSData(base64Encoded: decodeData2 as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data:decodedData2! as Data)
        postedImageView.image = decodedImage2
        
        let commentTextView = cell.viewWithTag(4) as! UITableView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = items[(indexPath as NSIndexPath).row]
        
        let decodeData = (base64Encoded:dict["profileImage"])
        let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data:decodedData! as Data)
        nowtableViewImage = decodedImage!
        
        nowtableViewUserName = (dict["username"] as? String)!
        
        let decodeData2 = (base64Encoded:dict["postImage"])
        let decodedData2 = NSData(base64Encoded: decodeData2 as! String, options:
            NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data:decodedData2! as Data)
        nowtableViewImage = decodedImage2!
        
        performSegue(withIdentifier: "sns", sender: nil)
        
    }
    
    func loadAllData() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let firebase = Database.database().reference(fromURL: "https://happystagram-98ec1.firebaseio.com/").child("Posts")
        
        firebase.queryLimited(toLast: 10).observe(.value) {
            (snapshot, error) in
            
            var tempItems = [NSDictionary]()
            for item in(snapshot.children){
                let child = item as! DataSnapshot
                let dict = child.value
                tempItems.append(dict as! NSDictionary)
            }
            
            self.items = tempItems
            self.items = self.items.reversed()
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
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
    
    
    
    @IBAction func showAlbum(_ sender: Any) {
        openPhoto()
    }
    
    
    @IBAction func showCamera(_ sender: Any) {
        openCamera()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            passImage = pickedImage
            performSegue(withIdentifier: "next", sender: nil)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "next"){
            let editVC:EditViewController = segue.destination as! EditViewController
            editVC.willEditImage = passImage
        }
        
        if(segue.identifier == "sns"){
            let snsVC:SnsViewController = segue.destination as! SnsViewController
            snsVC.detailImage = nowtableViewImage
            snsVC.detailProfile = nowtableViewUserImage
            snsVC.detailUserName = nowtableViewUserName
        }
    }

}


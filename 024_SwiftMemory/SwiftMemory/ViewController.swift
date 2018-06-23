//
//  ViewController.swift
//  SwiftMemory
//
//  Created by Atsushi on 2018/06/03.
//  Copyright © 2018年 Atsushi. All rights reserved.
//
//FIXME     ARが動かない

import UIKit
import Firebase
import CoreLocation
import SDWebImage
import ARCL
import MapKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    CLLocationManagerDelegate {

    let mapView:MKMapView! = MKMapView()
    var sceneLocationView = SceneLocationView()

    var nowIdo:Double = Double()
    var nowKeido:Double = Double()

    var locationManager: CLLocationManager!
    var fullName = String()
    var posts = [Post]()
    var posst = Post()

    var pathToImage_Array = [String]()
    var address_Array = [String]()
    var fullName_Array = [String]()
    var postImage_Array = [String]()
    var comment_Array = [String]()

    var addressforpin_Array = [String]()
    var onlyAddress_Array = [String]()

    var country:String = String()
    var administrativeArea:String = String()
    var subAdministrativeArea:String = String()
    var locality:String = String()
    var subLocality:String = String()
    var thoroughfare:String = String()
    var subThoroughfare:String = String()

    var address:String = String()

    var distance = 0

    @IBOutlet var tableView: UITableView!

    var profileImage:URL!
    var passImage:UIImage = UIImage()

    var uid = Auth.auth().currentUser?.uid

    //AR用
    //緯度
    var lat_Array = [Double]()
    //経度
    var long_Array = [Double]()

    let refreshControl = UIRefreshControl()
    var nowtableViewImage = UIImage()
    var nowtableViewUserName = String()
    var nowtableViewUserImage = UIImage()

    @IBOutlet var idoLabel: UILabel!

    @IBOutlet var keidoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action:#selector(refresh), for:UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        catchLocationData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.posts = [Post]()
            self.fetchPosts()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    func catchLocationData(){
        if CLLocationManager.locationServicesEnabled() {

            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    //送信時に緯度経度を別枠で送信して、
    //pinで指す or AR
    //Postsの取得
    func fetchPosts(){
        let ref = Database.database().reference()
        //もしアドレスがDB内にあれば
        if self.address != ""{
            ref.child("address").child(self.address).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                let postsSnap = snap.value as? [String : AnyObject]
                if postsSnap == nil{
                    return
                }
                for (_,post) in postsSnap!{
                    if let userID = post["userID"] as? String{
                        self.pathToImage_Array = [String]()
                        self.address_Array = [String]()
                        self.fullName_Array = [String]()
                        self.postImage_Array = [String]()
                        self.comment_Array = [String]()
                        self.posst = Post()
                        if let pathToImage = post["pathToImage"] as? String,let address = post["address"] as? String,let comment = post["comment"] as? String,let fullName = post["fullName"] as? String,let postImage = post["postImage"] as? String
                        {
                            self.posst.pathToImage = pathToImage
                            self.posst.address = address
                            self.posst.comment = comment
                            self.posst.fullName = fullName
                            self.posst.postImage = postImage

                            self.pathToImage_Array.append(self.posst.pathToImage)
                            self.address_Array.append(self.posst.address)
                            self.comment_Array.append(self.posst.comment)
                            self.fullName_Array.append(self.posst.fullName)
                            self.postImage_Array.append(self.posst.postImage)
                            //比較して入れるものを限る
                            if (self.posst.address == self.address)
                            {
                                self.posts.append(self.posst)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }

            })
        }
    }

    func addressforPinPost(){
        //address以下がないのでそこを改善する
        let ref = Database.database().reference()
        //もしアドレスがDB内にあれば
        if self.address != ""{
            ref.child("AddressforPin").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                let postsSnap = snap.value as? [String : AnyObject]
                if postsSnap == nil{
                    return
                }
                self.addressforpin_Array = [String]()
                for (_,post) in postsSnap!{
                    if let userID = post["addressforpin"] as? String{
                        self.posst = Post()
                        if let addressforpin = post["addressforpin"] as? String{
                            self.posst.addressforpin = addressforpin
                            self.addressforpin_Array.append(self.posst.addressforpin)
                            //重複された内容を消去する
                            let orderedSet:NSOrderedSet = NSOrderedSet(array: self.addressforpin_Array)
                            self.onlyAddress_Array = orderedSet.array as! [String]
                        }
                    }
                }

            })
        }
    }

    //TableViewのデリゲートメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 665
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //プロフィール
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        //ここがstring型ではない可能性があるので注意 SDWebImageを使う
        let profileImageUrl = URL(string:self.posts[indexPath.row].pathToImage as String)!
        profileImageView.sd_setImage(with: profileImageUrl)
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        //ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = self.posts[indexPath.row].fullName
        //投稿画像
        let postedImageView = cell.viewWithTag(3) as! UIImageView
        let postedImageViewURL = URL(string:self.posts[indexPath.row].postImage as String)!
        postedImageView.sd_setImage(with: postedImageViewURL)
        //コメント
        let commentTextView = cell.viewWithTag(4) as! UITextView
        commentTextView.text = self.posts[indexPath.row].comment

        return cell
    }

    func openCamera(){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    func openPhoto(){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            passImage = pickedImage
        }
        //カメラ画面(アルバム画面)を閉じる処理
        picker.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier:"next",sender:nil)
    }

    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        let editVC:EditViewController = segue.destination as! EditViewController
        editVC.uid = uid
        editVC.profileImage = self.profileImage! as URL
        editVC.passImage = passImage
        editVC.address = self.address
        editVC.fullName = fullName
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
        }
    }

    /*******************************************

     //位置情報取得に関するメソッド

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
        nowIdo = newLocation.coordinate.latitude
        nowKeido = newLocation.coordinate.latitude
        self.reverseGeocode(latitude: Double(idoLabel.text!)!, longitude: Double(keidoLabel.text!)!)
    }

    // 逆ジオコーディング処理(緯度・経度を住所に変換)
    func reverseGeocode(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemark, error) -> Void in
            let placeMark = placemark?.first
            if let country = placeMark?.country {
                self.country = country
            }
            if let administrativeArea = placeMark?.administrativeArea {
                self.administrativeArea = administrativeArea
            }
            if let subAdministrativeArea = placeMark?.subAdministrativeArea {
                self.subAdministrativeArea = subAdministrativeArea
            }
            if let locality = placeMark?.locality {
                self.locality = locality
            }
            if let subLocality = placeMark?.subLocality {
                self.subLocality = subLocality
            }
            if let thoroughfare = placeMark?.thoroughfare {
                self.thoroughfare = thoroughfare
            }
            if let subThoroughfare = placeMark?.subThoroughfare {
                self.subThoroughfare = subThoroughfare
            }
            self.address = self.country + self.administrativeArea + self.subAdministrativeArea
                + self.locality + self.subLocality
        })
    }

    //住所から緯度経度を取得
    // ジオコーディング処理(住所を緯度・経度に変換)
    func geocode() {
        self.sceneLocationView.frame = self.view.bounds
        for i in 0..<self.onlyAddress_Array.count {
            let address = self.onlyAddress_Array[i]
            let geocoder = CLGeocoder()
            //ここから非同期
            geocoder.geocodeAddressString(address) {
                placemarks, error in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                self.lat_Array.append(lat!)
                self.long_Array.append(lon!)
                //距離に換算
                var distance_Array:Array = [Int]()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // your code here
                    //非同期だからiの値は全て入った状態のものになっているからfor文に入った時に配列の中身を超した回数回ってしまう
                    for q in 0...i {
                        let nowPlace:CLLocation = CLLocation(latitude: self.nowIdo, longitude: self.nowKeido)
                        let coordinate = CLLocationCoordinate2D(latitude: self.lat_Array[q], longitude: self.long_Array[q])
                        let location = CLLocation(coordinate: coordinate, altitude: 300)
                        self.distance = Int(location.distance(from: nowPlace))
                        //距離を配列の中に入れて、配列に入れて小さい順に並び替える
                        distance_Array.append(self.distance)
                        distance_Array.sort { $0 < $1 }
                        let image1 = UIImage(named: "\(q)a.png")
                        //現在地からの距離も出す
                        let resizeImages = self.resizeUIImageByWidth(image: image1!, width: Double(q*10)+70.0)
                        let annotationNode1 = LocationAnnotationNode(location: location, image: resizeImages)
                        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode1)

                        let closeButton = UIButton()
                        closeButton.frame = CGRect(x:0, y: self.view.frame.size.height-70, width: 70, height: 70)
                        closeButton.layer.cornerRadius = 50.0
                        closeButton.backgroundColor = UIColor.white
                        closeButton.addTarget(self, action: #selector(self.tap), for: .touchUpInside)
                        self.sceneLocationView.addSubview(closeButton)

                        //MapOpenButton
                        let mapButton = UIButton()
                        mapButton.frame = CGRect(x:self.view.frame.size.width-70, y: self.view.frame.size.height-70, width: 70, height: 70)
                        mapButton.layer.cornerRadius = 50.0
                        mapButton.backgroundColor = UIColor.blue
                        mapButton.addTarget(self, action: #selector(self.openMap), for: .touchUpInside)
                        self.sceneLocationView.addSubview(mapButton)
                    }
                    self.sceneLocationView.run()
                    self.view.addSubview(self.sceneLocationView)
                }
            }
        }
    }

    @objc func refresh(){
        posts = [Post]()
        fetchPosts()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    @IBAction func camera(_ sender: Any) {
        openCamera()
    }

    @IBAction func album(_ sender: Any) {

        openPhoto()
    }

    @IBAction func openARCamera(_ sender: Any) {

        //Firebaseから全部の住所を取得 ok
        addressforPinPost()

        //取得した住所を重複なしで緯度経度に変換
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            self.geocode()
        }
    }

    @objc func openMap(){
        self.sceneLocationView.pause()
        self.sceneLocationView.removeFromSuperview()
        mapView.frame = self.view.bounds
        for i in 0..<lat_Array.count{
            lat_Array = lat_Array.sorted { $0 < $1 }
            long_Array = long_Array.sorted { $0 < $1 }
            /// 以下を追加 ///
            let coordinate = CLLocationCoordinate2DMake(lat_Array[i],long_Array[i])
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated:true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat_Array[i],long_Array[i])
            annotation.title = "ここに写真があります。"
            annotation.subtitle = "近くに行くとタイムラインから閲覧できます。"
            mapView.addAnnotation(annotation)
        }
        let closeButton = UIButton()
        closeButton.frame = CGRect(x:0, y: self.view.frame.size.height-70, width: 70, height: 70)
        closeButton.layer.cornerRadius = 50.0
        closeButton.backgroundColor = UIColor.white
        closeButton.addTarget(self, action: #selector(self.closeMap), for: .touchUpInside)
        mapView.addSubview(closeButton)
        self.view.addSubview(mapView)
    }

    @objc func closeMap(){
        mapView.removeFromSuperview()
    }
    @objc func tap(){ // buttonの色を変化させるメソッド
        self.sceneLocationView.pause()
        self.sceneLocationView.removeFromSuperview()
    }
    func resizeUIImageByWidth(image: UIImage, width: Double) -> UIImage {
        // オリジナル画像のサイズから、アスペクト比を計算
        let aspectRate = image.size.height / image.size.width
        // リサイズ後のWidthをアスペクト比を元に、リサイズ後のサイズを取得
        let resizedSize = CGSize(width: width, height: width * Double(aspectRate))
        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


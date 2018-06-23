//
//  ViewController.swift
//  swiftWonderList
//
//  Created by Atsushi on 2018/05/27.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var titleArr = [String]()
    var label:UILabel = UILabel()
    
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        back.layer.cornerRadius = 2.0
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        title(todo)
        if UserDefaults.standard.object(forKey: "array") != nil {
            titleArr = UserDefaults.standard.object(forKey: "array") as! [String]
        }
        
        if UserDefaults.standard.object(forKey: "image") != nil {
            let numberString = UserDefaults.standard.string(forKey: "image")
            
            ImageView.image = UIImage(named: numberString! + ".jpg")
        }
        
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        配列を文字の中に入れる
        titleArr.append(textField.text!)
        
//        配列をアプリ内に保存する
        UserDefaults.standard.set(titleArr, forKey: "array")
        
        if UserDefaults.standard.object(forKey: "array") != nil{
            
            titleArr = UserDefaults.standard.object(forKey: "array") as! [String]
            
            textField.text = ""
            tableView.reloadData()
        }
        
//        キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.layer.cornerRadius = 10.0
        label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = titleArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        値を渡す
        
        count = Int(indexPath.row)
        
//        画面を遷移
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next"{
            
            let nextVC = segue.destination as! NextViewController
            
            nextVC.selectedNumber = count
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            titleArr.remove(at: indexPath.row)
            
            UserDefaults.standard.set(titleArr, forKey: "array")
            
            tableView.reloadData()
        }else if editingStyle == .insert{
            
        }
    }

}


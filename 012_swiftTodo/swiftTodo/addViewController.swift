//
//  addViewController.swift
//  swiftTodo
//
//  Created by Atsushi on 2018/05/22.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class addViewController: UIViewController {


    @IBOutlet weak var textField: UITextField!
    
    var array = [String]()
    
    @IBAction func add(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: "array") != nil {
            
            //keyがarrayのデータを取得
            array = UserDefaults.standard.object(forKey: "array") as! [String]
        }
        
        //取得した配列に要素を追加
        array.append(textField.text!)
        
        UserDefaults.standard.set(array, forKey: "array")
        
        self.navigationController?.popViewController(animated: true)
    }

}

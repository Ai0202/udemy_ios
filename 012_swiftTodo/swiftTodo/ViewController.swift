//
//  ViewController.swift
//  swiftTodo
//
//  Created by Atsushi on 2018/05/21.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var resultArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //ページを表示するたびに呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ユーザーデフォルトにarrayというキーが存在すれば
        if UserDefaults.standard.object(forKey: "array") != nil {
            
            //arrayというキーのデータを取り出して変数に格納
            resultArray = UserDefaults.standard.object(forKey: "array") as! [String]
        }
        
        //numberOfSections tableView tableViewを再読み込み
        tableView.reloadData()
    }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セクションの中のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        
        cell.textLabel?.text = resultArray[indexPath.row]
        
        return cell
    }
    
    
    //削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //配列からスライドされたセルの番号の要素を削除
            resultArray.remove(at: indexPath.row)
            
            //削除した後の配列を保存
            print(resultArray)
            UserDefaults.standard.set(resultArray, forKey: "array")
            
            tableView.reloadData()
        }
    }


}


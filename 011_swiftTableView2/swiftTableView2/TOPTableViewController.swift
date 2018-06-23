//
//  TOPTableViewController.swift
//  swiftTableView2
//
//  Created by Atsushi on 2018/05/14.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class TOPTableViewController: UITableViewController {
    
    var box = String()


    //セクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //セクションの中のセルの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    //セルの中身
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        box = "わたった？"
        cell.textLabel?.text = "日本絶景"
        
        cell.detailTextLabel?.text = "webサイトを確認する"
        
        cell.imageView?.image = UIImage(named: "japan.png")

        return cell
    }
    
    //セルが選択された時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController: secondViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as! secondViewController
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        secondViewController.box = box
    }

}

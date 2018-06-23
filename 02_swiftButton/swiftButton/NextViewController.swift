//
//  NextViewController.swift
//  swiftButton
//
//  Created by Atsushi on 2018/05/13.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var changeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func tap(_ sender: Any) {
        changeText.text = "暗号が解除されました"
    }

}

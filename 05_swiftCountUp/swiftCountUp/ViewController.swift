//
//  ViewController.swift
//  swiftCountUp
//
//  Created by Atsushi on 2018/05/13.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    var count = 0
    
    
    @IBAction func plus(_ sender: Any) {
        count = count + 1
        countLabel.text = String(count)
    }
    

    @IBAction func minus(_ sender: Any) {
        count = count - 1
        countLabel.text = String(count)
    }
    
}


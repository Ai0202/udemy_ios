//
//  ViewController.swift
//  swiftImageView
//
//  Created by Atsushi on 2018/05/13.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    
    var count = 0

    @IBAction func change(_ sender: Any) {
        
        if (count == 1) {
            backImage.image = UIImage(named: "back1.jpg")
            count = 0
        } else if(count == 0) {
            backImage.image = UIImage(named: "back2.jpg")
            count = 1
        }
        
    }


}


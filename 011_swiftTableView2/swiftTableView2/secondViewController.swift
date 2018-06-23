//
//  secondViewController.swift
//  swiftTableView2
//
//  Created by Atsushi on 2018/05/14.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {
    
    var box = String()

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = box
    }

}

//
//  ViewController.swift
//  keisan
//
//  Created by Atsushi on 2018/05/13.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count = 10
    var minus = 11
    var multiplication = 12
    var division = 13
    var firstName = "atsushi"
    var lastName = "ikeda"
    var res = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        count = count + 1
        
        minus = minus - 5
        
        multiplication = multiplication * 4
        
        division = division / 13
        
        res = firstName + " " + lastName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


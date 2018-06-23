//
//  SettingViewController.swift
//  swiftWonderList
//
//  Created by Atsushi on 2018/05/27.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet weak var sv: UIScrollView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var vc = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vc.frame = CGRect(x: 0, y: 0, width: 800, height: 80)
        
        for i in 0..<10{
            let button:UIButton = UIButton()
            button.tag = i
            button.frame = CGRect(x: (i*80), y: 0, width: 80, height: 80)
            let buttonImage:UIImage = UIImage(named: String(i) + ".jpg")!
            button.setImage(buttonImage, for: .normal)
            button.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
            vc.addSubview(button)
            
        }
        
        sv.addSubview(vc)
        sv.contentSize = vc.bounds.size
        
    }
    
    @objc func selectImage(sender:UIButton) {
        print(sender.tag)
        backImageView.image = UIImage(named: String(sender.tag) + ".jpg")
        
        UserDefaults.standard.set(String(sender.tag), forKey: "image")
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

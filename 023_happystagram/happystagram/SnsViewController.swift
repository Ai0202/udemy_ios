//
//  SnsViewController.swift
//  happystagram
//
//  Created by Atsushi on 2018/06/02.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Social

class SnsViewController: UIViewController {

    var detailImage = UIImage()
    
    var detailProfile = UIImage()
    
    var detailUserName = String()
    
    var myComposeView:SLComposeViewController!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImage.image = detailImage
        label.text = detailUserName
        image.image = detailImage
        profileImage.layer.cornerRadius = 8.0
        profileImage.clipsToBounds = true
        
    }

    @IBAction func shareTwitter(_ sender: Any) {
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        //投稿するテキスト
        let string = "#Happystagram" + "photo by" + label.text!
        myComposeView.setInitialText(string)
        myComposeView.add(image.image)
        
        //表示する
        self.present(myComposeView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

//
//  previewViewController.swift
//  swiftSnapchatCamera
//
//  Created by Atsushi on 2018/05/26.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class previewViewController: UIViewController {
    
    var image:UIImage?
    @IBOutlet weak var UIImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIImage.image = image
    }
    
    
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

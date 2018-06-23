//
//  customPage.swift
//  swiftOnBoarding
//
//  Created by Atsushi on 2018/05/27.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import Foundation
import SwiftyOnboard

class CustomPage: SwiftyOnboardPage {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}

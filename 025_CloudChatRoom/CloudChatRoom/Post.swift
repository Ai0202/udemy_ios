//
//  Post.swift
//  CloudChatRoom
//
//  Created by Atsushi on 2018/06/07.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var country:String = String()
    var administrativeArea:String = String()
    var subAdministrativeArea:String = String()
    var locality:String = String()
    var subLocality:String = String()
    var thoroughfare:String = String()
    var subThoroughfare:String = String()
    
    var pathToImage:String!
    var roomName:String!
    var roomRule:String!
    var userID:String!
}

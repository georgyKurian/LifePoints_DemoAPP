//
//  AppUser.swift
//  Test_01
//
//  Created by Jithin Paul on 2017-12-10.
//  Copyright © 2017 Jithin Paul. All rights reserved.
//

import UIKit

class AppUser:NSObject{
    var username:String?
    var bio:String?
    var gps:String?
    
    init(_ value:[String:Any]) {
        self.username = value["username"] as? String
        self.bio = value["bio"] as? String
        self.gps = value["gps"] as? String
    }
}

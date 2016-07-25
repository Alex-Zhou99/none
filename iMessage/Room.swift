
//
//  Room.swift
//  iMessage
//
//  Created by Edward on 7/25/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import Foundation
import UIKit

class Room {
    var caption: String!
    var thumbnail: String!
    var id: String!
    
    init(key: String, snapshot: Dictionary<String, AnyObject >){
        self.id = key
        self.caption = snapshot["caption"] as! String
    }
}
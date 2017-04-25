//
//  Notification.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/24/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift

class Notification: Object {
    dynamic var FireTime = Date()
    dynamic var Message = ""
    dynamic var id = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    convenience init(fireTime date: Date, message label: String) {
        self.init()
        self.FireTime = date
        self.Message = label
        self.id = UUID().uuidString
    }
}

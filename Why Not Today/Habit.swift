//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
    dynamic var name = ""
    dynamic var type = ""
    var datesCompleted = List<DateCompleted>()
    
    convenience init(n: String, t: String){
        self.init()
        self.name = n
        self.type = t
    }
}

class DateCompleted: Object {
    dynamic var dateCompleted: Date = Date()
    dynamic var successfullyCompleted: Int = 0
    dynamic var Habit: Habit?
}


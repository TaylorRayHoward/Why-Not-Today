//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
    dynamic var name = ""
    dynamic var type = ""
    dynamic var id = ""
    var datesCompleted = List<DateCompleted>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    convenience init(n: String, t: String){
        self.init()
        self.name = n
        self.type = t
        self.id = UUID().uuidString
    }
}

class DateCompleted: Object {
    dynamic var dateCompleted: Date = Date()
    dynamic var successfullyCompleted: Int = 0
    dynamic var Habit: Habit?
    
    convenience init(dateCompleted date: Date, success: Int, for habit: Habit) {
        self.init()
        self.dateCompleted = date
        self.successfullyCompleted = success
        self.Habit = habit
    }
}


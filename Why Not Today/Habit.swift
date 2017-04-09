//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
    dynamic var name = ""
    dynamic var type = ""
    var datesCompleted = [DateCompleted]()
}

class DateCompleted {
    var dateCompleted: Date = Date()
    var successfullyCompleted: Bool? = nil
}


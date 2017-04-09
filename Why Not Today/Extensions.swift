//
// Created by Taylor Howard on 4/9/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
extension Date {
    func dayNumberOfWeek() -> Int? {
        //http://stackoverflow.com/a/35006174
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

//
// Created by Taylor Howard on 4/9/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension Date {
    func numberDayFromDate() -> Int? {
        //http://stackoverflow.com/a/35006174
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    func yearFromDate() -> Int? {
        return Calendar.current.dateComponents([.year], from: self).year
    }
    func numberMonthFromDate() -> Int? {
        return Calendar.current.dateComponents([.month], from: self).month
    }
}

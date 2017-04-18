//
// Created by Taylor Howard on 4/9/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import JTAppleCalendar

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

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        
        
        var components = DateComponents()
        components.year = 2016
        components.month = 1
        components.day = 1
        let startDate = Calendar.current.date(from: components)!
        let params = ConfigurationParameters(startDate: startDate, endDate: Date())
        
        return params
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState,
                  indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        changeCellDisplay(cell, with: calendarView, withState: cellState)
        cell.circleView.isHidden = Calendar.current.startOfDay(for: date) != selectedDate
        return cell
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setMonthLabel(from: visibleDates)
        setYearLabel(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        self.selectedDate = Calendar.current.startOfDay(for: date)
        guard let validCell = cell as? CustomCell else { return }
        validCell.circleView.isHidden = false
        self.reload()
//        TODO Show list of Habits that they have created and then allow them to say completed or not completed
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.circleView.isHidden = true
    }
}

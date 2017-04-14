//
//  ViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/11/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        calendarView.visibleDates { (visibleDates) in
            self.setMonthLabel(from: visibleDates)
            self.setYearLabel(from: visibleDates)
        }
        calendarView.scrollToDate(Date())
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setMonthLabel(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    func setYearLabel(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        yearLabel.text =  "\(date.yearFromDate()!)"
    }
    
    func changeCellDisplay(_ cell: CustomCell, with calendar: JTAppleCalendarView, withState cellState: CellState) {
        cell.dateLabel.text = cellState.text
        
//        TODO cellState.day in our list of dates
        
//        if cellState.date in list of dates {
//            cell.circleView.isHidden = false
//        }
//        else {
//            cell.circleView.isHidden = true
//        }
        
        if cellState.dateBelongsTo != .thisMonth {
            cell.dateLabel.textColor = UIColor.gray
        }
        else {
            cell.dateLabel.textColor = UIColor(rgb: 0xD9E5D6)
        }
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
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setMonthLabel(from: visibleDates)
        setYearLabel(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        guard let validCell = cell as? CustomCell else { return }
//        TODO Show list of Habits that they have created and then allow them to say completed or not completed
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        guard let validCell = cell as? CustomCell else { return }
    }
}

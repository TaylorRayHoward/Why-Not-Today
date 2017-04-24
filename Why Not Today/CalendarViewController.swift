//
//  ViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/11/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

//TODO refactor out all realm things into outer class
import UIKit
import JTAppleCalendar
import RealmSwift

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var confirmDenyTable: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var formatter = DateFormatter()
//    lazy var realm = try! Realm()
    var habits: Results<Object>!
    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        reload()
        calendarView.visibleDates { (visibleDates) in
            self.setMonthLabel(from: visibleDates)
            self.setYearLabel(from: visibleDates)
        }
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false,
                                  preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        confirmDenyTable.tableFooterView = UIView()
        let initialDate = Calendar.current.startOfDay(for: Date())
        calendarView.selectDates([initialDate], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        selectedDate = initialDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
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
        //TODO add filling green/red circle for if you have completed your things for the day
        cell.dateLabel.text = cellState.text
        
        //try to pull out
        if cellState.dateBelongsTo != .thisMonth {
            cell.dateLabel.textColor = UIColor.gray
        }
        else {
            cell.dateLabel.textColor = UIColor(rgb: 0xD9E5D6)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO fix terrible colors
        let cell = confirmDenyTable.dequeueReusableCell(withIdentifier: "ConfirmDenyCell", for: indexPath) as! ConfirmDenyHabitCell
        //TODO could pull out
        cell.confirmButton?.tag = indexPath.row
        cell.confirmButton?.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        cell.denyButton?.tag = indexPath.row
        cell.denyButton?.addTarget(self, action: #selector(denyAction), for: .touchUpInside)
        var habit = habits[indexPath.row] as! Habit
        cell.nameLabel?.text = habit.name
        
        
        habit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", habit.name).first! as! Habit
        
        if let dc = habit.datesCompleted.filter("dateCompleted = %@", selectedDate).first {
            if dc.successfullyCompleted == 1 {
                cell.backgroundColor = UIColor.green
            }
            else if dc.successfullyCompleted == -1 {
                cell.backgroundColor = UIColor.red
            }
        }
        else {
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func confirmAction(sender: UIButton) {
        resolveCompletionAction(tag: sender.tag, status: 1)
    }
    
    func denyAction(sender: UIButton) {
        resolveCompletionAction(tag: sender.tag, status: -1)
    }
    
    func reload() {
        habits = DBHelper.sharedInstance.getAll(ofType: Habit.self)
        self.confirmDenyTable.reloadData()
    }
    
    func resolveCompletionAction(tag: Int, status: Int) {
        var habit = habits[tag] as! Habit
        let exists = habit.datesCompleted.filter("dateCompleted = %@", selectedDate).first != nil
        
        if(!exists) {
            let dc = DateCompleted(dateCompleted: selectedDate, success: status, for: habit)
            habit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", habit.name).first! as! Habit
            DBHelper.sharedInstance.addDateCompleted(for: habit, with: dc)
        }
        else {
            habit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", habit.name).first! as! Habit
            let dc = habit.datesCompleted.filter("dateCompleted = %@", selectedDate).first!
            DBHelper.sharedInstance.updateDateCompleted(dc, success: status, date: nil)
        }
        
        
        let indexPath = calendarView.indexPathsForSelectedItems![0]
        let cell = calendarView.cellForItem(at: indexPath) as! CustomCell
        let percentage = getProgressBarPercentage(forDate: selectedDate)
        
        if percentage != nil {
            cell.progressView.setProgress(percentage!, animated: true)
            cell.progressView.isHidden = false
        }
        reload()
        
    }
}


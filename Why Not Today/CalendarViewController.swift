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
    var habits: Results<Object>!
    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        initialLoad()
        confirmDenyTable.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        calendarView.deselectAllDates()
        calendarView.selectDates([selectedDate], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        reload(forDate: selectedDate.endOfDay)
        calendarView.reloadData()
    }

    @IBAction func addHabit(_ sender: UIBarButtonItem) {
        let totalHabits = DBHelper.sharedInstance.getAll(ofType: Habit.self)
        let storyboard  = UIStoryboard(name: "Main", bundle: Bundle.main)
        if totalHabits.count == 0 {
            let calendarViewVc = storyboard.instantiateViewController(withIdentifier: "CalendarView") as! CalendarViewController
            let habitTableVc = storyboard.instantiateViewController(withIdentifier: "HabitTable") as! HabitTableViewController
            let createHabit = storyboard.instantiateViewController(withIdentifier: "CreateHabit") as! CreateHabitViewController
            navigationController?.setViewControllers([calendarViewVc, habitTableVc, createHabit], animated: true)
        }
        else {
            let habitTableVc = storyboard.instantiateViewController(withIdentifier: "HabitTable") as! HabitTableViewController
            navigationController?.pushViewController(habitTableVc, animated: true)
        }
    }
    func initialLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let initialDate = Date().startOfDay
        reload(forDate: Date().endOfDay)
        calendarView.visibleDates { (visibleDates) in
            self.setMonthLabel(from: visibleDates)
            self.setYearLabel(from: visibleDates)
        }
        calendarView.deselectAllDates(triggerSelectionDelegate: true)
        calendarView.scrollToDate(initialDate, triggerScrollToDateDelegate: true, animateScroll: false,
                preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        calendarView.selectDates(from: initialDate, to: initialDate, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        selectedDate = initialDate
        calendarView.reloadData()
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
        yearLabel.text =  "\(date.year)"
    }
    
    func changeCellDisplay(_ cell: CustomCell, with calendar: JTAppleCalendarView, withState cellState: CellState) {
        cell.dateLabel.text = cellState.text
        cell.isUserInteractionEnabled = true

        if cellState.dateBelongsTo != .thisMonth && cellState.date < Date(){
            cell.dateLabel.textColor = UIColor.gray
        }
        else if(cellState.date > Date()) {
            cell.dateLabel.textColor = UIColor.gray
            cell.isUserInteractionEnabled = false
        }
        else {
            cell.dateLabel.textColor = UIColor(rgb: 0xD9E5D6)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    //TODO make for efficient on queries
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = confirmDenyTable.dequeueReusableCell(withIdentifier: "ConfirmDenyCell", for: indexPath) as! ConfirmDenyHabitCell
        cell.confirmButton?.tag = indexPath.row
        cell.confirmButton?.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        cell.denyButton?.tag = indexPath.row
        cell.denyButton?.addTarget(self, action: #selector(denyAction), for: .touchUpInside)
        var habit = habits[indexPath.row] as! Habit
        cell.nameLabel?.text = habit.name
        
        
        habit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", habit.name).first! as! Habit
        
        if let dc = habit.datesCompleted.filter("dateCompleted = %@", selectedDate).first {
            if dc.successfullyCompleted == 1 {
                changeButtonBackground(forState: .approve, at: cell, animated: false)
            }
            else if dc.successfullyCompleted == -1 {
                changeButtonBackground(forState: .deny, at: cell, animated: false)
            }
        }
        else {
            changeButtonBackground(forState: .neutral, at: cell, animated: false)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard  = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "StatsController") as! StatsViewController
        let habit = habits[indexPath.row] as! Habit
        destination.habit = habit
        navigationController?.pushViewController(destination, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func confirmAction(sender: UIButton) {
        resolveCompletionAction(forStatus: .approve, at: sender.tag)
    }
    
    func denyAction(sender: UIButton) {
        resolveCompletionAction(forStatus: .deny, at: sender.tag)
    }
    
    func reload(forDate date: Date) {
        habits = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("createDate < %@", date)
        self.confirmDenyTable.reloadData()
    }
    
    func resolveCompletionAction(forStatus status: ApproveDeny, at tag: Int) {
        var habit = habits[tag] as! Habit
        let exists = habit.datesCompleted.filter("dateCompleted = %@", selectedDate).first != nil
        let dc = exists ? habit.datesCompleted.filter("dateCompleted = %@", selectedDate).first! : DateCompleted(dateCompleted: selectedDate, success: status.rawValue, for: habit)
        var toggle = false

        if !exists {
            habit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", habit.name).first! as! Habit
            DBHelper.sharedInstance.addDateCompleted(for: habit, with: dc)
        }
        else {
            habit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", habit.name).first! as! Habit
            if dc.successfullyCompleted == status.rawValue {
                toggle = true
                DBHelper.sharedInstance.deleteDateCompleted(dc)
            }
            else {
                DBHelper.sharedInstance.updateDateCompleted(dc, success: status.rawValue, date: nil)
            }
        }
        
        
        var indexPath = calendarView.indexPathsForSelectedItems![0]
        let customCell = calendarView.cellForItem(at: indexPath) as? CustomCell
        
        if customCell != nil {
            let percentage = getProgressBarPercentage(forDate: selectedDate)
            
            if percentage.0 != nil {
                customCell!.progressView.setProgress(percentage.0!, animated: true)
                customCell!.progressView.isHidden = false
            }
            else {
                customCell!.progressView.setProgress(0, animated: true)
            }
            if percentage.1 != nil {
                customCell!.failedProgressView.setProgress(percentage.1!, animated: true)
                customCell!.failedProgressView.isHidden = false
            }
            else {
                customCell!.failedProgressView.setProgress(0, animated: true)
            }
        }
        
        indexPath = IndexPath(row: tag, section: 0)
        let habitCell = confirmDenyTable.cellForRow(at: indexPath) as! ConfirmDenyHabitCell
        if toggle {
            changeButtonBackground(forState: .neutral, at: habitCell, animated: true)
            return
        }
        changeButtonBackground(forState: status, at: habitCell, animated: true)
        
        if(isCompleteForDay(forDate: selectedDate)) {
            postponeNotifications()
        }
    }
    
    func changeButtonBackground(forState state: ApproveDeny, at cell: ConfirmDenyHabitCell, animated: Bool) {
        switch(state){
        case .approve:
            if animated {
                UIView.transition(with: cell.confirmButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell.confirmButton.setImage(#imageLiteral(resourceName: "OkayClicked"), for: .normal)
                }, completion: nil)
                UIView.transition(with: cell.denyButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell.denyButton.setImage(#imageLiteral(resourceName: "CancelDefault"), for: .normal)
                }, completion: nil)
            }
            else {
                cell.confirmButton.setImage(#imageLiteral(resourceName: "OkayClicked"), for: .normal)
                cell.denyButton.setImage(#imageLiteral(resourceName: "CancelDefault"), for: .normal)
            }
        case .deny:
            if animated {
                UIView.transition(with: cell.denyButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell.denyButton.setImage(#imageLiteral(resourceName: "CancelClicked"), for: .normal)
                }, completion: nil)
                UIView.transition(with: cell.confirmButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell.confirmButton.setImage(#imageLiteral(resourceName: "OkayDefault"), for: .normal)
                }, completion: nil)

            }
            else {
                cell.confirmButton.setImage(#imageLiteral(resourceName: "OkayDefault"), for: .normal)
                cell.denyButton.setImage(#imageLiteral(resourceName: "CancelClicked"), for: .normal)
            }
        case .neutral:
            if animated {
                UIView.transition(with: cell.denyButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell.denyButton.setImage(#imageLiteral(resourceName: "CancelDefault"), for: .normal)
                }, completion: nil)
                UIView.transition(with: cell.confirmButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    cell.confirmButton.setImage(#imageLiteral(resourceName: "OkayDefault"), for: .normal)
                }, completion: nil)
            }
            else {
                cell.confirmButton.setImage(#imageLiteral(resourceName: "OkayDefault"), for: .normal)
                cell.denyButton.setImage(#imageLiteral(resourceName: "CancelDefault"), for: .normal)
            }
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
        let params = ConfigurationParameters(startDate: startDate, endDate: Date(), numberOfRows: 6, calendar: nil, generateInDates: nil, generateOutDates: .tillEndOfRow, firstDayOfWeek: nil, hasStrictBoundaries: nil)
        
        return params
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState,
                  indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        changeCellDisplay(cell, with: calendarView, withState: cellState)
        cell.selectedView.isHidden = Calendar.current.startOfDay(for: date) != selectedDate
        cell.progressView.isHidden = true
        cell.failedProgressView.isHidden = true
        cell.failedProgressView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        
        let percent = getProgressBarPercentage(forDate: date)
        if percent.0 != nil {
            cell.progressView.isHidden = false
            cell.progressView.setProgress(percent.0!, animated: false)
        }
        if percent.1 != nil {
            cell.failedProgressView.isHidden = false
            cell.failedProgressView.setProgress(percent.1!, animated: false)
        }
        
        return cell
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setMonthLabel(from: visibleDates)
        setYearLabel(from: visibleDates)
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.selectedDate = Calendar.current.startOfDay(for: date)
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.alpha = 0.0
        validCell.selectedView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            validCell.selectedView.alpha = 1.0
        }, completion: {
            finished in validCell.selectedView.isHidden = false
        })
        self.reload(forDate: date.endOfDay)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        UIView.animate(withDuration: 0.25, animations: {
            validCell.selectedView.alpha = 0.0
        }, completion: {
            finished in validCell.selectedView.isHidden = true
        })
    }
}

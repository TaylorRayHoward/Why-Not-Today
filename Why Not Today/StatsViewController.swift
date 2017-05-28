//
// Created by Taylor Howard on 5/28/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//
import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tuesLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thursLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!

    var labelList = [UILabel]()
    var habit: Habit? = nil

    override func viewDidLoad() {
        labelList = [sunLabel, monLabel, tuesLabel, wedLabel, thursLabel, friLabel, satLabel]
        super.viewDidLoad()
        setDayPercentText()
    }
    func setDayPercentText() {
        for day in iterateEnum(dayOfWeek.self){
            let label = labelList[day.rawValue - 1]
            label.text = "\(calcDay(forDay: day))%"
        }
    }
    func calcDay(forDay weekday: dayOfWeek) -> Int {
        var startDate = habit!.createDate
        var weekDaysSince = 1
        while(!startDate.isSameDay(date: Date().endOfDay)) {
            if(startDate.weekday == weekday.rawValue) {
                weekDaysSince += 1
            }
            startDate = startDate.add(1.days)
        }
        let daysCompleted = habit!.datesCompleted.filter {
            $0.dateCompleted.weekday == weekday.rawValue && $0.successfullyCompleted == 1
        }
        return Int(round(Double(daysCompleted.count)/Double(weekDaysSince) * 100))
    }
}

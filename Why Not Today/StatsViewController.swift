//
// Created by Taylor Howard on 5/28/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//
import UIKit
import UICountingLabel

class StatsViewController: UIViewController {
    @IBOutlet weak var monLabel: UICountingLabel!
    @IBOutlet weak var tuesLabel: UICountingLabel!
    @IBOutlet weak var wedLabel: UICountingLabel!
    @IBOutlet weak var thursLabel: UICountingLabel!
    @IBOutlet weak var friLabel: UICountingLabel!
    @IBOutlet weak var satLabel: UICountingLabel!
    @IBOutlet weak var sunLabel: UICountingLabel!

    var labelList = [UICountingLabel]()
    var habit: Habit? = nil

    override func viewDidLoad() {
        labelList = [sunLabel, monLabel, tuesLabel, wedLabel, thursLabel, friLabel, satLabel]
        super.viewDidLoad()
        setDayPercentText()
    }
    func setDayPercentText() {
        for day in iterateEnum(dayOfWeek.self){
            let label = labelList[day.rawValue - 1]
            label.format = "%d%%"
            label.method = UILabelCountingMethod.linear
            label.count(from: 0, to: CGFloat(calcDay(forDay: day)), withDuration: 1.0)
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

//
//  Notification.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/24/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications

class Notification: Object {
    dynamic var FireTime = Date()
    dynamic var Message = ""
    dynamic var id = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    convenience init(fireTime date: Date, message label: String) {
        self.init()
        self.FireTime = date
        self.Message = label
        self.id = UUID().uuidString
    }
}

func cancelNotifs() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
}

func setupNotificaiton(for notif: Notification) {
    let content = UNMutableNotificationContent()
    content.title = "Why Not Today Reminder"
    content.subtitle = "Daily Reminder"
    content.body = notif.Message
    
    var date = DateComponents()
    date.hour = notif.FireTime.getHour()!
    date.minute = notif.FireTime.getMinute()!
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
    let request = UNNotificationRequest(identifier: notif.id, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func postponeNotifications(for date: Date) {
    let notifications = DBHelper.sharedInstance.getAll(ofType: Notification.self)
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
    cancelNotifs()
    for object in notifications {
        let notif = object as! Notification
        setupNotificaiton(for: notif)
    }
}

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
import DateToolsSwift

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
    let content = setupContent(with: notif)
    var date = DateComponents()
    date.hour = notif.FireTime.hour
    date.minute = notif.FireTime.minute
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
    let request = UNNotificationRequest(identifier: notif.id, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func setupNotification(for notif: Notification, at date: Date) {
    let content = setupContent(with: notif)
    var dc = DateComponents()
    dc.hour = date.hour
    dc.minute = date.minute
    dc.day = date.day
    dc.month = date.month
    let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: false)
    let request = UNNotificationRequest(identifier: notif.id, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func setupContent(with notif: Notification) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = "Why Not Today Reminder"
    content.subtitle = "Daily Reminder"
    content.body = notif.Message
    return content
}

func postponeNotifications() {
    cancelNotifs()
    
    let notifs = DBHelper.sharedInstance.getAll(ofType: Notification.self)
    for notif in notifs {
        let notification = notif as! Notification
        var date = Date()
        date.hour(notification.FireTime.hour)
        date.minute(notification.FireTime.minute)
        date = date.add(1.days)
        setupNotification(for: notification, at: date)
    }
}

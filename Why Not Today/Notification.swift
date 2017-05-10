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
    if notif.FireTime > Date() {
        setupNotification(for: notif, at: notif.FireTime)
    }
    else {
        let d = notif.FireTime.add(1.days)
        setupNotification(for: notif, at: d)
    }
}

func setupNotification(for notif: Notification, at date: Date) {
    let content = setupContent(with: notif)
    var dc = DateComponents()
    var d = date
    for i in 0...10 {
        d = d.add(i.minutes)
        dc.hour = d.hour
        dc.minute = d.minute
        dc.day = d.day
        dc.month = d.month
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: false)
        let request = UNNotificationRequest(identifier: notif.id + "\(i)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
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

func removeNotification(id: String) {
    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
        var identifiers: [String] = []
        for notification:UNNotificationRequest in notificationRequests {
            if notification.identifier.range(of: id) != nil {
                identifiers.append(notification.identifier)
            }
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

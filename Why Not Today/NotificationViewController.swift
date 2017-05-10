//
//  NotificationViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/22/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    @IBAction func testNotif(_ sender: UIButton) {
//        scheduleNotification(inSeconds: 5, completion: { success in
//            if success {
//                print("success")
//            } else {
//                print ("error")
//            }
//        })
//    }
    
    @IBOutlet weak var notificationTable: UITableView!
    
    var notifications: Results<Object>!
    override func viewDidLoad() {
        super.viewDidLoad()
        askForNotifications()
        reload()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    func setupTable() {
        notificationTable.delegate = self
        notificationTable.dataSource = self
        notificationTable.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTable.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row] as! Notification
        cell.messageLabel.text = notification.Message
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.timeLabel.text = dateFormatter.string(from: notification.FireTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard  = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "CreateNotificationView") as! CreateNotificationViewController
        let notif = notifications[indexPath.row] as! Notification
        destination.id = notif.id
        destination.message = notif.Message
        destination.time = notif.FireTime
        navigationController?.pushViewController(destination, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let notif = notifications[indexPath.row] as! Notification
            removeNotification(id: notif.id)
            DBHelper.sharedInstance.deleteNotification(notif)
            reload()
        }
    }
    
    
    func reload() {
        notifications = DBHelper.sharedInstance.getAll(ofType: Notification.self)
        notificationTable.reloadData()
    }
    
    func askForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            (granted, error) in
            
            if granted {
                print("Granted")
            }
            else {
                print(error?.localizedDescription ?? "")
            }
        })
    }
}

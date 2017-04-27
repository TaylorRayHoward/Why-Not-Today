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
        notificationTable.delegate = self
        notificationTable.dataSource = self
        askForNotifications()
        setupTable()
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
        cell.messageLabel.text = "This here is a long label"
        cell.timeLabel.text = "10:35 AM"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func reload() {
        notifications = DBHelper.sharedInstance.getAll(ofType: Notification.self)
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

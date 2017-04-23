//
//  NotificationViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/22/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController {

    @IBAction func testNotif(_ sender: UIButton) {
        scheduleNotification(inSeconds: 5, completion: { success in
            if success {
                print("success")
            } else {
                print ("error")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            (granted, error) in
            
            if granted {
                print("Granted")
            }
            else {
                print(error?.localizedDescription ?? "")
            }
        })
        // Dispose of any resources that can be recreated.
        
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        let notif = UNMutableNotificationContent()
        notif.title = "Test"
        notif.subtitle = "Test2"
        notif.body = "Test3"
        
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler:  { error in
            if error != nil {
                print(error ?? "")
                completion(false)
            } else {
                completion(true)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

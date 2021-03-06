//
//  CreateNotificationViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/25/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import UserNotifications

class CreateNotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataSentDelegate {

    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var id: String? = nil
    var message: String? = nil
    var time: Date? = nil
    
    var delegate: DataSentDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionsTableView.delegate = self
        actionsTableView.dataSource = self
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        if isEdit() {
            timePicker.date = time!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancelNotification(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func saveNotification(_ sender: UIBarButtonItem) {
        let notification = Notification(fireTime: timePicker.date, message: getMessage())
        if getMessage() == "" {
            let alert = UIAlertController(title: "Missing fields", message: "All fields cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if isEdit() {
            notification.id = id!
            DBHelper.sharedInstance.updateNotificaiton(notification)
        } else {
            DBHelper.sharedInstance.writeObject(objects: [notification])
        }
        
        setupNotificaiton(for: notification)
        _ = navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = actionsTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            cell.titleLabel.text = "Message"
            if isEdit() {
                cell.messageLabel.text = message!
            }
            else {
                cell.messageLabel.text = "Don't forget to log your completed habits"
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func userDidEnterData(data: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = actionsTableView.cellForRow(at: indexPath) as! MessageCell
        cell.messageLabel.text = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEditMessage" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! NotificationMessageViewController
            vc.previousText = getMessage()
            vc.delegate = self
        }
    }
    func getMessage() -> String {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = actionsTableView.cellForRow(at: indexPath) as! MessageCell
        return cell.messageLabel.text!
    }
    
    func isEdit() -> Bool {
        return id != nil && message != nil && time != nil
    }
    
}

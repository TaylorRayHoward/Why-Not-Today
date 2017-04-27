//
//  CreateNotificationViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/25/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(data: String)
}

class CreateNotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var delegate: DataSentDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionsTableView.delegate = self
        actionsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancelNotification(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func saveNotification(_ sender: UIBarButtonItem) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = actionsTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            cell.titleLabel.text = "Message"
            cell.messageLabel.text = "This is a tesasdfasdfasdfadsfadsfadsfadsfadsfadsfadsfasf"
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
        if indexPath.row == 0 {
            let storyboard  = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "NotificationMessageViewController") as! NotificationMessageViewController
            let cell = tableView.cellForRow(at: indexPath) as! MessageCell
            destination.previousText = cell.messageLabel.text!
            navigationController?.pushViewController(destination, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

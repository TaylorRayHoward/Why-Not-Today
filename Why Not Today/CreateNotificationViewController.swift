//
//  CreateNotificationViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/25/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit


class CreateNotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataSentDelegate {

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
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = actionsTableView.cellForRow(at: indexPath) as! MessageCell
            vc.previousText = cell.messageLabel.text!
            vc.delegate = self
        }
    }
}

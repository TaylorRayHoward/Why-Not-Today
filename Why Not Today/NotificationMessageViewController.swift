//
//  NotificationMessageViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/25/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(data: String)
}

class NotificationMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var previousText: String = ""
    var delegate: DataSentDelegate? = nil
    
    @IBOutlet weak var messageTable: UITableView!
    override func viewDidLoad() {
        messageTable.delegate = self
        messageTable.dataSource = self
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancelMessage(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveMessage(_ sender: UIBarButtonItem) {
        if delegate != nil {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = messageTable.cellForRow(at: indexPath) as! EditMessageCell
            if cell.messageInput.text != nil {
                let data = cell.messageInput.text!
                delegate!.userDidEnterData(data: data)
            }
            _ = navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTable.dequeueReusableCell(withIdentifier: "EditMessageCell") as! EditMessageCell
        cell.messageInput.text = previousText
        cell.messageInput.becomeFirstResponder()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

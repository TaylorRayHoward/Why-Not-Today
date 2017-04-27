//
//  NotificationMessageViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/25/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

class NotificationMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var previousText: String = ""
    @IBOutlet weak var messageTable: UITableView!
    override func viewDidLoad() {
        messageTable.delegate = self
        messageTable.dataSource = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelMessage(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveMessage(_ sender: UIBarButtonItem) {
        
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

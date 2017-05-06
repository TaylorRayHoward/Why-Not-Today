//
//  HabitNameViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 5/4/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

protocol UserEnteredDataDelegate {
    func userEnteredName(data: String, type: String)
}

class HabitEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: UserEnteredDataDelegate? = nil
    var type: String = ""

    @IBOutlet weak var nameTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTable.delegate = self
        nameTable.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveName(_ sender: UIBarButtonItem) {
        if delegate != nil {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = nameTable.cellForRow(at: indexPath) as! EditNameCell
            if cell.nameInput.text != nil {
                let data = cell.nameInput.text!
                delegate!.userEnteredName(data: data, type: type)
            }
        }
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditNameCell", for: indexPath) as! EditNameCell
            cell.nameInput.becomeFirstResponder()
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
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

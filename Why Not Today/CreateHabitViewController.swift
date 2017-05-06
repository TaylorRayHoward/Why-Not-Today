//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

class CreateHabitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserEnteredDataDelegate {

    @IBOutlet weak var createTable: UITableView!
    
    var id: String? = nil
    var name: String? = nil
    var category: String? = nil

    override func viewDidLoad(){
        super.viewDidLoad()
        createTable.delegate = self
        createTable.dataSource = self
    }


    @IBAction func cancelCreate(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func saveHabit(_ sender: UIBarButtonItem) {
        if(isEdit()) {

        }
        else {
            let habit = Habit(n: getName(), t: getCategory())
            DBHelper.sharedInstance.writeObject(objects: [habit])
            navigationController?.popViewController(animated: true)
        }
    }
    
    func presentIncompleteAlert() {
        let alert = UIAlertController(title: "Blank field", message: "All fields must be completed",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alert, animated: true)
    }
    
    
    func isEdit() -> Bool {
        return id != nil && name != nil && category != nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEditName" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! HabitEditViewController
            vc.type = "name"
            vc.delegate = self
        }
        if segue.identifier == "ToEditCategory" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! HabitEditViewController
            vc.type = "category"
            vc.delegate = self
        }
    }

    func userEnteredName(data: String, type: String) {
        switch(type){
            case "name":
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = createTable.cellForRow(at: indexPath) as! NameCell
                cell.nameField.text = data
            case "category":
                let indexPath = IndexPath(row: 1, section: 0)
                let cell = createTable.cellForRow(at: indexPath) as! CategoryCell
                cell.categoryField.text = data
            default:
                return
        }
    }

    func getName() -> String {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = createTable.cellForRow(at: indexPath) as! NameCell
        return cell.nameField.text!
    }

    func getCategory() -> String {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = createTable.cellForRow(at: indexPath) as! CategoryCell
        return cell.categoryField.text!

    }

}

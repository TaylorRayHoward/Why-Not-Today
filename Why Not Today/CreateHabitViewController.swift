//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

class CreateHabitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserEnteredDataDelegate {

    @IBOutlet weak var createTable: UITableView!
    
    var id: String? = nil
    var name: String? = nil

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
        let habit = Habit(n: getName())
        if getName() == "" {
            let alert = UIAlertController(title: "Missing fields", message: "All fields cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let dupe = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", getName()).first as? Habit
        if dupe != nil {
            let alert = UIAlertController(title: "Duplicate", message: "Cannot have a duplicate habit name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if(isEdit()) {
            habit.id = id!
            DBHelper.sharedInstance.updateHabit(habit)
        }
        else {
            DBHelper.sharedInstance.writeObject(objects: [habit])
        }
        navigationController?.popViewController(animated: true)
    }
    
    func presentIncompleteAlert() {
        let alert = UIAlertController(title: "Blank field", message: "All fields must be completed",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        self.present(alert, animated: true)
    }
    
    
    func isEdit() -> Bool {
        return id != nil && name != nil 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            if name != nil {
                cell.nameField.text = name!
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEditName" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! HabitEditViewController
            vc.type = "name"
            vc.delegate = self
            if isEdit() {
                vc.input = getName()
            }
        }
    }

    func userEnteredName(data: String, type: String) {
        switch(type){
            case "name":
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = createTable.cellForRow(at: indexPath) as! NameCell
                cell.nameField.text = data
            default:
                return
        }
    }

    func getName() -> String {
        return getNameCell().nameField.text!
    }

    func getNameCell() -> NameCell {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = createTable.cellForRow(at: indexPath) as! NameCell
        return cell
    }

}

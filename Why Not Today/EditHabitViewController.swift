//
//  EditHabitViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/8/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

class EditHabitViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!

    var nameText = ""
    var typeText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = nameText
        typeField.text = typeText
    }

    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func saveEdit(_ sender: UIBarButtonItem) {
        if (nameField?.text != nil && nameField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "") && (typeField?.text != nil && typeField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "") {
            let habit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", nameText).first! as! Habit

            let exists = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@", nameField.text!).first != nil
            if(!exists) {
                DBHelper.sharedInstance.updateHabit(habit, name: nameField.text!, type: typeField.text!)
            }

           _ = navigationController?.popViewController(animated: true)
        }
        else{
            let alert = UIAlertController(title: "Blank field", message: "All fields must be completed",
                    preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true)
        }
    }
}

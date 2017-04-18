//
//  EditHabitViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/8/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import RealmSwift

//TODO pull out all/most of realm stuff
class EditHabitViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!

    let realm = try! Realm()
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
        if (nameField?.text != nil && nameField.text != "") || (typeField?.text != nil && typeField.text != "") {
            let habit = realm.objects(Habit.self).filter("name == '\(nameText)' AND type == '\(typeText)'").first!

            try! realm.write {
                habit.name = nameField.text!
                habit.type = typeField.text!
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

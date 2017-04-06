//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import RealmSwift

class CreateHabitViewController: UIViewController {

    let realm = try! Realm()
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typeText: UITextField!

    override func viewDidLoad(){

    }
    @IBAction func cancelCreate(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func saveHabit(_ sender: UIBarButtonItem) {
        let habit = Habit()
        if (nameText?.text != nil && nameText.text != "") || (typeText?.text != nil && typeText.text != "") {
            habit.name = nameText.text!
            habit.type = typeText.text!

            try! self.realm.write {
                self.realm.add(habit)
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

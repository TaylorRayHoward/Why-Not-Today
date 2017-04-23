//
// Created by Taylor Howard on 4/5/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

//TODO pull out all/most of realm stuff
class CreateHabitViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typeText: UITextField!

    override func viewDidLoad(){

    }
    @IBAction func cancelCreate(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func saveHabit(_ sender: UIBarButtonItem) {
        if (nameText?.text != nil && nameText.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "") && (typeText?.text != nil && typeText.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "") {
            let habit = Habit(n: nameText.text!, t: typeText.text!)
            
            let exists = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter("name = %@ AND type = %@", nameText.text!, typeText.text!).first != nil
            if(!exists) {
                DBHelper.sharedInstance.writeObject(objects: [habit])
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

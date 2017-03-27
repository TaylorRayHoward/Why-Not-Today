//
//  HabitTableViewController.swift
//  Why Not Today
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import RealmSwift

class Habit: Object {
    dynamic var name = ""
    dynamic var type = ""
}


class HabitTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
}

class HabitTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let realm = try! Realm()
    var habits: Results<Habit>!
    @IBOutlet weak var habitTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        habitTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        habitTable.dataSource = self
        habitTable.delegate = self
        reload()
    // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = habitTable.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitTableViewCell
        cell.nameLabel?.text = habits[indexPath.row].name
        cell.typeLabel?.text = habits[indexPath.row].type
        return cell
    }
    @IBAction func addHabit(_ sender: UIBarButtonItem) {
        let habit = Habit()
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let habitName = alert!.textFields![0]
            let habitType = alert!.textFields![1]
            if let enteredText = habitName.text {
                if enteredText == "" {
                    return
                }
                habit.name = enteredText
            }
            if let enteredText = habitType.text {
                habit.type = enteredText
            }

            try! self.realm.write {
                self.realm.add(habit)
            }
            self.reload()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func reload(){
        habits = self.realm.objects(Habit.self)
        for h in habits {
            print(h.name)
        }
        self.habitTable.reloadData()
    }
}

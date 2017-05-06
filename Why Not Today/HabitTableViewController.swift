//
//  HabitTableViewController.swift
//  Why Not Today
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import RealmSwift


class HabitTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var habits: Results<Object>!
    @IBOutlet weak var habitTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        habitTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        habitTable.dataSource = self
        habitTable.delegate = self
        reload()
        habitTable.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = habitTable.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitTableViewCell
        let habit = habits[indexPath.row] as! Habit
        
        cell.nameLabel?.text = habit.name
        cell.typeLabel?.text = habit.type
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard  = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "CreateHabit") as! CreateHabitViewController
        let habit = habits[indexPath.row] as! Habit
        destination.id = habit.id
        destination.category = habit.type
        destination.name = habit.name
        navigationController?.pushViewController(destination, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let cell = tableView.cellForRow(at: indexPath) as! HabitTableViewCell

            let predicate = NSPredicate(format: "name == %@", "\(cell.nameLabel!.text!)")
            let deleteHabit = DBHelper.sharedInstance.getAll(ofType: Habit.self).filter(predicate).first! as! Habit
            DBHelper.sharedInstance.deleteHabit(deleteHabit)
            
            reload()
        }
    }

    func reload() {
        habits = DBHelper.sharedInstance.getAll(ofType: Habit.self)
        self.habitTable.reloadData()
    }
}

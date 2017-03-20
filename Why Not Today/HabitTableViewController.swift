//
//  HabitTableViewController.swift
//  Why Not Today
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import UIKit


class HabitTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var habitTable: UITableView!
    var habits: [String] = ["This", "Is", "A", "Test"]
    override func viewDidLoad() {
        super.viewDidLoad()
        habitTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        habitTable.dataSource = self
        habitTable.delegate = self
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
        let cell: UITableViewCell = habitTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = habits[indexPath.row]
        return cell
    }
    @IBAction func addHabit(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            if let enteredText = textField.text {
                if enteredText == "" {
                    return
                }
                self.habits.append(enteredText)
            }
            self.habitTable.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

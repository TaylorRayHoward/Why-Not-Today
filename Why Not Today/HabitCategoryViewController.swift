//
//  HabitCategoryViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 5/4/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

class HabitCategoryViewController: UIViewController {

    @IBAction func saveName(_ sender: UIBarButtonItem) {

    }
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  NotificationMessageViewController.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/25/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit

class NotificationMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelMessage(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveMessage(_ sender: UIBarButtonItem) {
        
    }
}

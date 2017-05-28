//
// Created by Taylor Howard on 5/28/17.
// Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//
import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tuesLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thursLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    
    var habit: Habit? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

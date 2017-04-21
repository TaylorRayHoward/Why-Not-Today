//
//  CustomCell.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/11/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var fillView: UIView!
}

class HabitTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
}

class ConfirmDenyHabitCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
}

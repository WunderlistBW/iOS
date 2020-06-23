//
//  ListCell.swift
//  Wunderlist
//
//  Created by Nonye on 6/23/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    var listEntryController = ListEntryController()
    var isCompleted: Bool = false
    
    // MARK: OUTLETS
    @IBOutlet weak var reminderName: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    var listEntry: ListEntry? {
        didSet {
        }
    }
}

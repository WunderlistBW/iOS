//
//  ListCell.swift
//  Wunderlist
//
//  Created by Nonye on 6/23/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    var listEntryController: ListController?
    
    var isCompleted: Bool = false
    // MARK: OUTLETS
    @IBOutlet weak var reminderName: UILabel!
    @IBOutlet weak var isCompleteButton: UIButton!
    var listEntry: ListEntry? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
         guard let task = listEntry else { return }
        reminderName.text = task.name
     }
    // MARK: - ACTIONS
    @IBAction func reminderTapped(_ sender: UIButton) {
        guard let listEntry = listEntry else { return }
        listEntry.isComplete.toggle()
        sender.setImage(listEntry.isComplete ? UIImage(systemName: "alarm.fill") :
            UIImage(systemName: "alarm"), for: .normal)
        do {
            try CoreDataStack.shared.mainContext.save()
            listEntryController?.firebaseSendToServer(entry: listEntry)
            updateViews()
        } catch {
            CoreDataStack.shared.mainContext.reset()
            NSLog("Error saving contact (changing reminder/complete boolean): \(error)")
        }
    }
}

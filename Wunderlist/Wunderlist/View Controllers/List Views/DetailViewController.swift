//
//  DetailViewController.swift
//  Wunderlist
//
//  Created by Nonye on 6/23/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - OUTLETS
    @IBOutlet weak var entryTitleField: UITextField!
    @IBOutlet weak var entryDetailsTextView: UITextView!
    @IBOutlet weak var entryDatePicker: UIDatePicker!
    @IBOutlet weak var reminderSegmentControl: UISegmentedControl!
//    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    // MARK: - PROPERTIES
    var listController: ListController?
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "YYYY-MM-d HH:MM:ss"
        return formatter
    }()
    var wasEdited = false
    var listEntry: ListEntry?
    // MARK: - ACTIONS
    //actually an edit button
    @IBAction func saveButtonTapped(_ sender: Any) {
        isEditing.toggle()
        updateViews()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let entryTitle = entryTitleField.text,
                !entryTitle.isEmpty,
                let entryText = entryDetailsTextView.text,
                !entryText.isEmpty,
                let listEntry = listEntry else { return }
            let name = entryTitleField.text
            listEntry.name = name
            // TO DO:
//            ListController.updateList(<#ListController#>)
//
//            do {
//                try CoreDataStack.shared.save(in: listEntry)
//            } catch {
//                NSLog("Error saving managed object context (during list edit): \(error)")
//            }
        }
    }
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        if editing { wasEdited = true }
//        entryTitleField.isUserInteractionEnabled = editing
//        entryDetailsTextView.isUserInteractionEnabled = editing
//        entryDatePicker.isUserInteractionEnabled = editing
//        navigationItem.hidesBackButton = editing
//    }
    func updateViews() {
        guard let date = listEntry?.dueDate else { return }
        let dateFromString = dateFormatter.date(from: date)
        guard let formattedDate = dateFromString else { return }
        
        guard let listEntry = listEntry else { return }
        entryTitleField.text = listEntry.name
        entryDatePicker.date = formattedDate
        entryTitleField.isUserInteractionEnabled = isEditing
        entryDetailsTextView.isUserInteractionEnabled = isEditing
        entryDatePicker.isUserInteractionEnabled = isEditing
        reminderSegmentControl.isUserInteractionEnabled = isEditing
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

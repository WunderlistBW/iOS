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
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var entryDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        navigationItem.rightBarButtonItem = editButtonItem
    }
//    private init() {
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    // MARK: - PROPERTIES
    var listController: ListController?
    var listEntryController = ListEntryController()
    var wasEdited = false
    var listEntry: ListEntry?
    // MARK: - ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let entryTitle = entryTitleField.text,
                !entryTitle.isEmpty,
                let entryText = entryTextView.text,
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
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        entryTitleField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        entryDatePicker.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    private func updateViews() {
        guard let listEntry = listEntry else { return }
        entryTitleField.text = listEntry.name
        entryTitleField.isUserInteractionEnabled = isEditing
        entryTextView.isUserInteractionEnabled = isEditing
        #warning("Bad unwrapping")
        entryDatePicker.date = listEntry.dueDate!
        entryDatePicker.isUserInteractionEnabled = isEditing
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

//
//  AddViewController.swift
//  Wunderlist
//
//  Created by Nonye on 6/23/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit
// TODO - ADD COMPLETED CONTROL ON SCREEN VC? - OUTLET FOR IT BELOW
class AddViewController: UIViewController {
    // MARK: - PROPERTIES
    var listController: ListController?
    var listEntry: ListEntry?
    // DATE FORMATTER
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "YYYY-MM-DD HH:MM:SS:SSS"
        return formatter
    }()
    // MARK: - OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    // In case we want to add that segmented complete control
    
    @IBOutlet weak var reminderSegment: UISegmentedControl!
    @IBOutlet weak var addDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - ACTIONS
    // TO DO - ADD CANCEL BUTTON ON VC
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    // TO SAVE A CREATED LIST ENTRY
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let listController = listController else { return }
        let dueDate = addDatePicker.date
        if let listEntry = listEntry {
            listEntry.name = name
            listEntry.dueDate = dueDate
            // update feature / function
        } else {
            do {
                try listController.createListEntry(with: name, dueDate: dueDate)
            } catch {
                print("Error creating entry from Add Entry VC")
            }
        }
        let alert = UIAlertController(title: "Saved", message: "Your list entry has been saved!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Finished",
                                      style: .default) { (_) -> Void in
                                        self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
} // EOC
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

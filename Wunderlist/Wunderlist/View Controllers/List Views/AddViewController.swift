//
//  AddViewController.swift
//  Wunderlist
//
//  Created by Nonye on 6/23/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit
enum Recurring: String, CaseIterable {
    case weekly = "weekly"
    case daily = "daily"
    case monthly = "monthly"
    case never = ""
}
// TODO - ADD COMPLETED CONTROL ON SCREEN VC? - OUTLET FOR IT BELOW
class AddViewController: UIViewController {
    // MARK: - PROPERTIES
    var listController: ListController?
    var listEntry: ListEntry?
    let notificationController = NotificationController()
    var userId = NEUserController.currentUserID?.user.id
    // DATE FORMATTER
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "YYYY-MM-d HH:MM:ss"
        return formatter
    }()
    // MARK: - OUTLETS
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    // In case we want to add that segmented complete control
    @IBOutlet weak var reminderSegment: UISegmentedControl!
    @IBOutlet weak var addDatePicker: UIDatePicker!
    @IBOutlet weak var detailsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        #warning("Should probably be moved to the table view so when they first open the app they are asked if they want notifications")
        self.notificationController.requestNotificationAuthorization()
    }
    private func updateViews() {
    }
    // MARK: - Life Cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpIdentitfiers()
    }
    // MARK: - ACTIONS
    // TO DO - ADD CANCEL BUTTON ON VC
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    // TO SAVE A CREATED LIST ENTRY
    @IBAction func save(_ sender: UIBarButtonItem) {
        let date = dateFormatter.string(from: addDatePicker.date)
        let body = detailsTextView.text
        guard let name = nameTextField.text else {
            print("Name of list is required")
            return
        }
        guard let uwUserId = userId else { return }
        var recurring: Recurring?
        if reminderSegment.selectedSegmentIndex == 3 {
            recurring = .never
        } else {
            let segment = reminderSegment.selectedSegmentIndex
            recurring = Recurring.allCases[segment]
        }
        switch reminderSegment.selectedSegmentIndex {
        case 4: recurring = Recurring.never
        case 3: recurring = Recurring.monthly
        case 2: recurring = Recurring.weekly
        case 1: recurring = Recurring.daily
        default: recurring = Recurring.never
        }
        guard let recurringString = recurring?.rawValue else { return }

        do {
        try listController?.createListEntry(with: name, body: body,
                                            recurring: recurringString,
                                            dueDate: date, id: uwUserId)
    } catch {
        }
        let alert = UIAlertController(title: "Saved", message: "Your list entry has been saved!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Finished",
                                      style: .default) { (_) -> Void in
                                        self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
        #warning("New addition, remember to check if breaking app")
    }
//        navigationController?.popViewController(animated: true)
//        guard let name = nameTextField.text,
//            let details = detailsTextView.text,
//            !name.isEmpty,
//            !details.isEmpty else { return }
//        guard let listController = listController, let uwUserId = userId?.user.id else { return }
//        let dateString = dateFormatter.string(from: addDatePicker.date)
//        let endOn = dateString
//        if let listEntry = listEntry {
//            listEntry.name = name
//            listEntry.body = details
//            // update feature / function
//        } else {
//            do {
//                try listController.createListEntry(with: name,
//                                                   body: details,
//                                                   recurring: "daily",
//                                                   completed: false,
//                                                   dueDate: endOn,
//                                                   id: uwUserId)
//            } catch {
//                print("Error creating entry from Add Entry VC")
//            }
//        }
//        let alert = UIAlertController(title: "Saved", message: "Your list entry has been saved!",
//                                      preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Finished",
//                                      style: .default) { (_) -> Void in
//                                        self.navigationController?.popViewController(animated: true)
//        })
//        present(alert, animated: true, completion: nil)
  }

 // EOC
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

extension AddViewController {
    private func setUpIdentitfiers() {
//        self.addDatePicker.accessibilityIdentifier = "Main.Create.DatePicker"
//        self.cancelButton.accessibilityIdentifier = "Main.Create.CancelButton"
    }
}

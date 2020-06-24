//
//  AddViewController.swift
//  Wunderlist
//
//  Created by Nonye on 6/23/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    // MARK: - PROPERTIES
    var listController: ListController?
    var listEntry: ListEntry?
    var listEntryController: ListEntryController?
    // MARK: - OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    // In case we want to add that segmented complete control
    @IBOutlet weak var isCompleteControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // MARK: - ACTIONS
    // TO DO - ADD CANCEL BUTTON ON VC
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
        //this dismisses the nav controller and goes back to the table view
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
//        guard let name = nameTextField.text, !name.isEmpty else { return }
//        //TO DO - FIX
//        let listStatus = isCompleteControl.selectedSegmentIndex
//        let status = ListStatus.allCases[listStatus]
//        //TO DO - FIXXXXX
//        guard let listEntry = ListEntry(name: name, listId: _,
//        dueDate: _, isRecurring: _, dayOfWeek: _, isComplete: _, context: _) else { }
//        listEntryController?.getEntry(name: name)
//        do {
//            try CoreDataStack.shared.mainContext.save()
//            navigationController?.dismiss(animated: true, completion: nil)
//        } catch {
//            NSLog("Error saving managed object context: \(error)")
//        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
} // EOD

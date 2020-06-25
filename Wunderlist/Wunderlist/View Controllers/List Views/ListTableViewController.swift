//
//  ListTableViewController.swift
//  Wunderlist
//
//  Created by Nonye on 6/23/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {

    // MARK: - Properties
    @IBOutlet weak var addButton: UIBarButtonItem!
    var neUserController = NEUserController.shared
    var listController = ListController()

    // MARK: - Life Cycles
    var coreDataStack = CoreDataStack.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIdentifiers()
        NEUserController.shared.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()

    }

    @IBAction func entryStatusTapped(_ sender: Any) {
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // listController.fetchListFromServer() // Web backend
        listController.firebaseFetchFromServer { result in
            print(result)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let bearer = neUserController.bearer
        guard bearer != nil else {
            performSegue(withIdentifier: "ListSegue", sender: self)
            return
        }
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return listController.lists?.count ?? 0
        return listController.listCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
            as? ListCell else { return UITableViewCell() }
        cell.listEntry = listController.getListEntry(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = coreDataStack.fetchedResultsController.object(at: indexPath)
            listController.firebaseDeleteListFromServer(list) { error in
                DispatchQueue.main.async {
                    let context = CoreDataStack.shared.mainContext
                    context.delete(list)
                    do {
                        try context.save()
                        tableView.reloadData()
                    } catch {
                        context.reset()
                        NSLog("Error saving managed object context (delete task): \(error)")
                    }
                }}
        }
    }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateSegue" {
            if let addVC = segue.destination as? AddViewController {
                addVC.listController = listController
            }
        }
        // DetailViewController
        if segue.identifier == "DetailSegue" {
            if let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.listEntry = listController.getListEntry(at: indexPath)
                detailVC.listController = listController
            }
        }
    }
}

// MARK: - EXTENSION
extension ListTableViewController: PersistentStoreControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension ListTableViewController: UserStateDelegate {
    func userLoggedIn() {
       // listController.fetchListFromServer() // web backend
        listController.firebaseFetchFromServer { result in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(result)
        }
    }

}

extension ListTableViewController {
    private func setUpIdentifiers {
        self.tableView.accessibilityIdentifier = "Main.ListTable"
        self.addButton.accessibilityIdentifier = "Main.AddButton"
    }
}

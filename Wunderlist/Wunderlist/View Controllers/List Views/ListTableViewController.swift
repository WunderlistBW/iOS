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
    // MARK: - OUTLETS
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Life Cycles
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
        listController.fetchListFromServer()
         // Transition to log in view if conditions are met
        let bearer = NEUserController.currentUserID?.token
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
    // SEARCH BAR
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // TODO: Populate table view by leveraging isComplete boolean.
        return 0
    }

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
    // MARK: - DELETE LIST ITEM FROM SERVER & TABLE VIEW (uncomment after delete func done)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            let task = fetchedResultsController.object(at: indexPath)
//            listController.deleteListFromServer(task) { result in
//                guard let _ = try? result.get() else {
//                    return
//                }
//                DispatchQueue.main.async {
//                    let context = CoreDataStack.shared.mainContext
//                    context.delete(task)
//                    do {
//                        try context.save()
//                    } catch {
//                        context.reset()
//                        NSLog("Error saving managed object context (delete task): \(error)")
//                    }
//                }}
//        }
    }
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
        listController.fetchListFromServer()
    }
}
extension ListTableViewController: UISearchBarDelegate {
//    #warning("SEARCH METHOD -- this *should* work if I figure out what the replacement for fetch is, listcontroller.something")
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        var predicate: NSPredicate?
//        if searchBar.text?.count != 0 {
//            predicate = NSPredicate(format: "(name CONTAINS[cd] %@) || (recurring CONTAINS[cd] %@)", searchText, searchText)
//        }
//        let coreDataSearch = CoreDataStack.shared.fetchedResultsController.fetchedObjects
//        do {
//            try listController.fetchListFromServer()
//        } catch {
//            NSLog("Error performing fetch: \(error)")
//        }
//        tableView.reloadData()
//    }
}

extension ListTableViewController {
    private func setUpIdentifiers() {
        self.tableView.accessibilityIdentifier = "Main.ListTable"
    }
}

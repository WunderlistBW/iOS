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
    var coreDataStack = CoreDataStack.shared
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
        searchBar.delegate = self
        coreDataStack.delegate = self
        tableView.reloadData()
    }
    @IBAction func entryStatusTapped(_ sender: Any) {
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let bearer = NEUserController.currentUserID?.token
            guard bearer != nil else {
                self.performSegue(withIdentifier: "ListSegue", sender: self)
                return
            }
        }
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        listController.fetchListFromServer { error in
            if error != nil {
                print("Error fetching in viewWillAppear")
            }
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataStack.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
            as? ListCell else { return UITableViewCell() }
        cell.listEntry = CoreDataStack.shared.fetchedResultsController.object(at: indexPath)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = coreDataStack.fetchedResultsController.object(at: indexPath)
//            listController.deleteListFromServer(task) { result in
//                guard let _ = try? result.get() else {
//                    return
//                }
//                DispatchQueue.main.async {
                    let context = CoreDataStack.shared.mainContext
                    context.delete(task)
                    do {
                        try context.save()
                    } catch {
                        context.reset()
                        NSLog("Error saving managed object context (delete task): \(error)")
                    }
                }}
//        }
//    }
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
        tableView.reloadData()
    }
}

extension ListTableViewController: UserStateDelegate {
    func userLoggedIn() {
        listController.fetchListFromServer { error in
            if error != nil {
                print("Error fetching items on TVC")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
extension ListTableViewController: UISearchBarDelegate {
//    #warning("SEARCH METHOD -- this *should* work if I figure out what the replacement for fetch is, listcontroller.something")
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate: NSPredicate?
        if searchBar.text?.count != 0 {
            predicate = NSPredicate(format: "(name CONTAINS[cd] %@) || (recurring CONTAINS[cd] %@)", searchText, searchText)
        }
        // need to pass predicate here?
        let coreDataSearch = CoreDataStack.shared.fetchedResultsController.fetchedObjects
        do {
            try listController.fetchListFromServer()
        } catch {
            NSLog("Error performing fetch from server: \(error)")
        }
        tableView.reloadData()
    }
}

extension ListTableViewController {
    private func setUpIdentifiers() {
        self.tableView.accessibilityIdentifier = "Main.ListTable"
    }
}

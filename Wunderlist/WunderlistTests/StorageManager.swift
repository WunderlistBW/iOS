//
//  StroageManager.swift
//  WunderlistTests
//
//  Created by Cody Morley on 6/24/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit
import CoreData
@testable import Wunderlist


//This class will allow full testing of core data without persisting test data into the main app's persistent store.

class StorageManager {
    // MARK: - Properties -
    let persistentContainer: NSPersistentContainer!
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Inits -
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /*
    below isn't technically necessary, it would let us merge this type of core data manager into the production environment.
//    convenience init() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            fatalError("AppDelegate unavailable")
//        }
//        self.init(container: appDelegate.persistentContainer)
//    }
    */
    // MARK: - Actions -
    func insertListEntry(name: String, dueDate: Date, listId: UUID, isComplete: Bool) -> ListEntry? {
        guard let listEntry = NSEntityDescription.insertNewObject(forEntityName: "ListEntry", into: backgroundContext) as? ListEntry else { return nil }
        listEntry.name = name
        listEntry.dueDate = dueDate
        listEntry.listId = listId
        listEntry.isComplete = isComplete
        return listEntry
    }
    
    func fetchAll(sorted: Bool = true) -> [ListEntry] {
        let request: NSFetchRequest<ListEntry> = ListEntry.fetchRequest()
        if sorted {
            let dateSort = NSSortDescriptor(key: #keyPath(ListEntry.dueDate), ascending: true)
            let completeSort = NSSortDescriptor(key: #keyPath(ListEntry.isComplete), ascending: true)
            request.sortDescriptors = [dateSort, completeSort]
        }
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [ListEntry]()
    }
 
    func fetch(name: String) -> [ListEntry] {
        let request: NSFetchRequest<ListEntry> = ListEntry.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let dateSort = NSSortDescriptor(key: #keyPath(ListEntry.dueDate), ascending: true)
        request.sortDescriptors = [dateSort]
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [ListEntry]()
    }
 
    func remove(objectID: NSManagedObjectID) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
 
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
}

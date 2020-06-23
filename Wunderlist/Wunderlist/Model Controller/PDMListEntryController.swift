//
//  ListEntryController.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
import CoreData

class ListEntryController: NSObject {
    // MARK: - Properties
    var persistentStoreController: PersistentStoreController = CoreDataStack()
    var entryCount: Int {
        persistentStoreController.itemCount
    }
    var entries: [ListEntry]? {
        persistentStoreController.allItems as? [ListEntry]
    }
    var delegate: PersistentStoreControllerDelegate? {
        get {
            return persistentStoreController.delegate
        }
        set(newDelegate) {
            persistentStoreController.delegate = newDelegate
        }
    }
    // MARK: - Methods
    func createEntry(withName name: String, isRecurring: Bool?,
                     context: PersistentContext?, dueDate: Date? = Date(),
                     taskId: Int64?, isComplete: Bool? = false, dayOfWeek: Int64?) throws {
        let context = persistentStoreController.mainContext
        guard let dueDate = dueDate, let isRecurring = isRecurring,
            let taskId = taskId,
            let dayOfWeek = dayOfWeek,
            let isComplete = isComplete else { return }
        guard let entry = ListEntry(name: name, listId: Int64(taskId),
                                    dueDate: dueDate, isRecurring: isRecurring,
                                    dayOfWeek: Int64(dayOfWeek), isComplete: isComplete, context: context)
            else { throw NSError() }
        try persistentStoreController.create(item: entry, in: context)
    }
    func getEntry(at indexPath: IndexPath) -> ListEntry? {
        return persistentStoreController.fetchItem(at: indexPath) as? ListEntry
    }
    func deleteEntry(at indexPath: IndexPath) throws {
        guard let thisEntry = getEntry(at: indexPath) else { throw NSError() }
        try persistentStoreController.delete(thisEntry, in: nil)
    }
}

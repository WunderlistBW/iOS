//
//  ListController.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
import CoreData

class ListController {
    // MARK: - Properties
    
    var searchedListEntry: [ListRepresentation] = []
    var persistentStoreController: PersistentStoreController = CoreDataStack()
    var listCount: Int {
        persistentStoreController.itemCount
    }
    var lists: [ListRepresentation]? {
        persistentStoreController.allItems as? [ListRepresentation]
    }
    var delegate: PersistentStoreControllerDelegate? {
        get {
            return persistentStoreController.delegate
        }
        set(newDelegate) {
            persistentStoreController.delegate = newDelegate
        }
    }
    typealias CompletionHandler = (Error?) -> Void
    static let sharedInstance = ListController()
    private let databaseURL = URL(string: "https://wunderlist-api-2020.herokuapp.com/")! // set up database URL
    
    func putListToServer(list: ListEntry, completion: @escaping CompletionHandler = { _ in }) {
       // guard let userId = UserController.sharedInstance.userID else { return }
        let requestURL = databaseURL.appendingPathComponent("api/tasks") // set up endpoint for putToServer
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        do {
            request.httpBody = try JSONEncoder().encode(list.listRepresentation)
            let putString = String.init(data: request.httpBody!, encoding: .utf8)
            print(putString!)
        } catch {
            NSLog("Error encoding Entry: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { _, _, error in
            // need to assign ID's of the returned successful post
            if let error = error {
                print("Error fetching entries: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
        }.resume()
    }
    func fetchListFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let bearer = NEUserController.shared.bearer else { return }
        print(bearer)
      //  guard let userID = UserController.sharedInstance.userID else { return }
        let requestURL = databaseURL.appendingPathExtension("api/tasks") // set endpoint for fetch
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching list: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                print("No data returned in fetch")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            do {
                let listRepresentations =
                    Array(try JSONDecoder().decode([String: ListRepresentation].self, from: data).values)
                try self.updateList(with: listRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding plant representation: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    private func updateList(with representation: [ListRepresentation]) throws {
        let entriesWithId = representation.filter { $0.listId != nil }
        let identifiersToFetch = entriesWithId.compactMap { $0.listId! }
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithId))
        var entriesToCreate = representationByID
        let fetchRequest: NSFetchRequest<ListEntry> = ListEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingList = try context.fetch(fetchRequest)
                for list in existingList {
                    let listId = list.listId
                    guard let representation = representationByID[Int(listId)] else { continue }
                    self.update(listEntry: list, with: representation)
                    entriesToCreate.removeValue(forKey: Int(listId))
                }
                for representation in entriesToCreate.values {
                    ListEntry(listRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching entries for UUIDs: \(error)")
            }
        }
        try CoreDataStack.shared.save(in: context)
    }
    func deleteListFromServer(_ list: ListEntry, completion: @escaping CompletionHandler = { _ in}) {
        // TODO: Delete a list from server
    }
    private func update(listEntry: ListEntry, with representation: ListRepresentation) {
        listEntry.name = representation.name
        listEntry.dueDate = representation.dueDate
        listEntry.isComplete = representation.isComplete ?? false
    }
    func createListEntry(with name: String, listId: Int64, dueDate: Date? = Date(), isComplete: Bool? = false) throws {
        let context = persistentStoreController.mainContext
        guard  let list = ListEntry(name: name, listId: listId,
                                    dueDate: dueDate ?? Date(),
                                     isComplete: isComplete,
                                    context: context) else { return }
        putListToServer(list: list)
        do {
            try CoreDataStack.shared.save(in: context)
        } catch {
            print("Error saving list object \(error)")
        }
    }
    func delete(for list: ListEntry, context: PersistentContext) {
        deleteListFromServer(list)
        do {
            try CoreDataStack.shared.delete(list, in: context)
            try CoreDataStack.shared.save(in: context)
        } catch {
            context.reset()
            print("Error deleting listEntry from MOC \(error)")
        }
    }
    func getListEntry(at indexPath: IndexPath) -> ListEntry? {
        return persistentStoreController.fetchItem(at: indexPath) as? ListEntry
    }
    func deleteListEntry(at indexPath: IndexPath) throws {
        guard let thisListEntry = getListEntry(at: indexPath) else { throw NSError() }
        try persistentStoreController.delete(thisListEntry, in: nil)
    }
}

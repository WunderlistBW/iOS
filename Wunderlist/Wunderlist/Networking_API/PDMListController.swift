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
    var dataLoader: NetworkDataLoader?
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
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    private let databaseURL = URL(string: "https://wunderlist-node.herokuapp.com")!
    func putListToServer(list: ListEntry, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = databaseURL.appendingPathComponent("api/items")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        do {
            request.httpBody = try JSONEncoder().encode(list.listRepresentation)
            print("\(request.httpBody?.prettyPrintedJSONString)")
        } catch {
            NSLog("Error encoding Entry: \(error)")
            completion(.failure(.badAuth))
            return
        }
        dataLoader?.loadData(with: request) { _, _, error in
            if let error = error {
                print("Error fetching entries: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
                return
            }
        }
    }
    func fetchListFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let bearer = NEUserController.currentUserID?.token else { return }
        guard let currentUID = NEUserController.currentUserID?.user.id else { return }
     let requestURL = databaseURL.appendingPathComponent("api/items/\(currentUID)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("\(bearer)", forHTTPHeaderField: "Authorization")
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
            print(data.prettyPrintedJSONString!)
            do {
                let listRepresentations =
                    try Array(JSONDecoder().decode([ListRepresentation].self, from: data))
                try self.updateList(with: listRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding list representation: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    private func updateList(with representation: [ListRepresentation]) throws {
        let entriesWithId = representation.filter { $0.id != nil }
        let identifiersToFetch = entriesWithId.compactMap { $0.id! }
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithId))
        var entriesToCreate = representationByID
        let fetchRequest: NSFetchRequest<ListEntry> = ListEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingList = try context.fetch(fetchRequest)
                for list in existingList {
                    let id = list.id
                    guard let representation = representationByID[id] else { continue }
                    self.update(listEntry: list, with: representation)
                    entriesToCreate.removeValue(forKey: id)
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
        let listID = list.id
        let requestURL = databaseURL.appendingPathComponent("api/items/\(listID)")
        var request = URLRequest(url: requestURL)
        guard let token = NEUserController.currentUserID?.token else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.delete.rawValue
        dataLoader?.loadData(with: request) { _, _, error in
            if let error = error {
                NSLog("Error deleting list from server \(list): \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }
    }
    private func update(listEntry: ListEntry, with representation: ListRepresentation) {
        listEntry.name = representation.name
        listEntry.recurring = representation.recurring
        listEntry.completed = representation.completed ?? false
        listEntry.body = representation.body
        listEntry.id = representation.id ?? 0
        listEntry.dueDate = representation.dueDate
    }
    func createListEntry(with name: String, body: String?, recurring: String, completed: Bool? = false, dueDate: String, id: Int64) throws {
        let context = persistentStoreController.mainContext
        guard  let list = ListEntry(name: name,
                                    body: body,
                                    recurring: recurring,
                                    dueDate: dueDate,
                                    id: id,
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

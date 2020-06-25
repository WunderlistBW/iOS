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
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    private let databaseURL = URL(string: "https://wunderlist-97c2c.firebaseio.com/")!
    func firebaseSendToServer(entry: ListEntry, completion: @escaping () -> Void = { }) {
        let context = persistentStoreController.mainContext
        let uuid = entry.listId ?? UUID()
        let requestURL = databaseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard var representation = entry.listRepresentation else {
                completion()
                return
            }
            representation.listId = uuid.uuidString
            entry.listId = uuid
            try CoreDataStack.shared.save(in: context)
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion()
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error putting task to server: \(error!)")
                completion()
                return
            }

            completion()
        }.resume()
    }
    func putListToServer(list: ListEntry, completion: @escaping CompletionHandler = { _ in }) {
//        let requestURL = databaseURL.appendingPathComponent("api/tasks") Disabled for firebase
        var request = URLRequest(url: databaseURL)
        request.httpMethod = HTTPMethod.put.rawValue
        do {
            request.httpBody = try JSONEncoder().encode(list.listRepresentation)
            let putString = String.init(data: request.httpBody!, encoding: .utf8)
            print(putString!) // TODO: Fix formatting with codingKeys
        } catch {
            NSLog("Error encoding Entry: \(error)")
            completion(.failure(.badAuth))
            return
        }
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error fetching entries: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
                return
            }
        }.resume()
    }
    func firebaseFetchFromServer(completion: @escaping CompletionHandler = { _ in}) {
        let requestURL = databaseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard error == nil else {
                print("Error fetching task \(error!)")
                completion(.failure(.otherError))
                return
            }

            guard let data = data else {
                print("No data returned by data task")
                completion(.failure(.badData))
                return
            }

            do {
                let listRepresentations = Array(try JSONDecoder().decode([String: ListRepresentation].self, from: data).values)
                try self.updateList(with: listRepresentations)
                completion(.success(true))
            } catch {
                print("Error decoding entry represnetations: \(error)")
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
//    func fetchListFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
//        guard let bearer = NEUserController.shared.bearer else { return }
//        print(bearer)
//       let requestURL = databaseURL.appendingPathExtension("api/tasks") // disabled for firebase
//        var request = URLRequest(url: databaseURL)
//        request.httpMethod = "GET"
//      request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            if let error = error {
//                print("Error fetching list: \(error)")
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//                return
//            }
//            guard let data = data else {
//                print("No data returned in fetch")
//                DispatchQueue.main.async {
//                    completion(NSError())
//                }
//                return
//            }
//            print(String.init(data: data, encoding: .utf8))
//
//            do {
//                let listRepresentations =
//                    try Array(JSONDecoder().decode([String: ListRepresentation].self, from: data).values)
//                try self.updateList(with: listRepresentations)
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                print("Error decoding list representation: \(error)")
//                completion(error)
//                return
//            }
//        }.resume()
//    }
    private func updateList(with representation: [ListRepresentation]) throws {
        let entriesWithId = representation.filter { $0.listId != nil  }
        let identifiersToFetch = entriesWithId.compactMap { UUID(uuidString: $0.listId!) }
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithId))
        var entriesToCreate = representationByID
        let fetchRequest: NSFetchRequest<ListEntry> = ListEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "listId IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingList = try context.fetch(fetchRequest)
                for list in existingList {
                    guard let listId = list.listId,
                    let representation = representationByID[listId] else { continue }
                    self.update(listEntry: list, with: representation)
                    entriesToCreate.removeValue(forKey: listId)
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
        let listID = list.listId
        let requestURL = databaseURL.appendingPathComponent("api/tasks/\(listID)")
        var request = URLRequest(url: requestURL)
        guard let token = NEUserController.shared.bearer?.token else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.delete.rawValue
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error deleting list from server \(list): \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    private func update(listEntry: ListEntry, with representation: ListRepresentation) {
        listEntry.name = representation.name
        listEntry.dueDate = representation.dueDate
        listEntry.isComplete = representation.isComplete ?? false
    }
    func createListEntry(with name: String, dueDate: Date? = Date(), isComplete: Bool? = false, listId: UUID) throws {
        let context = persistentStoreController.mainContext
        guard  let list = ListEntry(name: name,
                                    dueDate: dueDate ?? Date(),
                                    isComplete: isComplete,
                                    listId: listId,
                                    context: context) else { return }
        putListToServer(list: list)
        firebaseSendToServer(entry: list)
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

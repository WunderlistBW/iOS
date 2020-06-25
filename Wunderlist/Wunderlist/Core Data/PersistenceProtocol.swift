//
//  PersistenceProtocol.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
import CoreData

protocol PersistentContext: NSManagedObjectContext {}

protocol Persistable {}

protocol PersistentStoreController: AnyObject {
    var delegate: PersistentStoreControllerDelegate? { get set }
    var allItems: [Persistable]? { get }
    var itemCount: Int { get }
    var mainContext: PersistentContext { get }
    
    func create(item: Persistable, in context: PersistentContext?) throws
    func fetchItem(at indexPath: IndexPath) -> Persistable?
    func delete(_ item: Persistable?, in context: PersistentContext?) throws
    func deleteInSelectedIndexPath(
        itemAtIndexPath indexPath: IndexPath,
        in context: PersistentContext?) throws
    func save(in context: PersistentContext?) throws
}

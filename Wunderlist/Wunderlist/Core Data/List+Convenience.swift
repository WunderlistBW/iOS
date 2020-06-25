//
//  List+Convenience.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
import CoreData

enum ListStatus: String, CaseIterable {
    case completedStatus
    case upcomingStatus
}

extension ListEntry: Persistable {
    convenience init?(name: String, dueDate: Date? = Date(), isComplete: Bool? = false, listId: UUID,
                      context: PersistentContext
    ) {
        guard let context = context as? NSManagedObjectContext, let isComplete = isComplete
            else { return nil }
        self.init(context: context)
        self.listId = listId
        self.name = name
        self.dueDate = dueDate
        self.isComplete = isComplete
    }
    @discardableResult convenience init?(listRepresentation: ListRepresentation, context: PersistentContext) {
        guard let isComplete = listRepresentation.isComplete else { return nil }
        let name = listRepresentation.name
        let dueDate = listRepresentation.dueDate
        let listId = listRepresentation.listId
        self.init(name: name,
                  dueDate: dueDate,
                  isComplete: isComplete, listId: listId,
                  context: context)
    }
    var listRepresentation: ListRepresentation? {
        guard let name = name, let listId = listId,
        let dueDate = dueDate else { return nil }
        return ListRepresentation(name: name, listId: listId,
                                  dueDate: dueDate, isComplete: isComplete)
    }
}

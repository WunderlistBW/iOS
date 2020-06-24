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
    convenience init?(name: String, listId: Int64?, dueDate: Date? = Date(), isComplete: Bool?,
                      context: PersistentContext
    ) {
        guard let context = context as? NSManagedObjectContext, let listId = listId, let isComplete = isComplete
            else { return nil }
        self.init(context: context)
        self.name = name
        self.listId = Int64(listId)
        self.dueDate = dueDate
        self.isComplete = isComplete
    }
    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.calendar = .autoupdatingCurrent
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    @discardableResult convenience init?(listRepresentation: ListRepresentation, context: PersistentContext) {
        guard let listKey = listRepresentation.listId,
            let isComplete = listRepresentation.isComplete else { return nil }
        let name = listRepresentation.name
        let dueDate = listRepresentation.dueDate
        self.init(name: name, listId: Int64(listKey),
                  dueDate: dueDate, isComplete: isComplete, context: context)
    }
    var listRepresentation: ListRepresentation? {
        guard let name = name,
        let dueDate = dueDate else { return nil }
        return ListRepresentation(name: name, listId: Int(listId),
                                  dueDate: dueDate, isComplete: isComplete)
    }
}

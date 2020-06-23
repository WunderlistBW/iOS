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
    convenience init?(name: String, listId: Int64?, dueDate: Date? = Date(),
                      isRecurring: Bool?, dayOfWeek: Int64?, isComplete: Bool?,
                      context: PersistentContext
    ) {
        guard let context = context as? NSManagedObjectContext, let isRecurring = isRecurring,
        let listId = listId, let dayOfWeek = dayOfWeek, let isComplete = isComplete
            else { return nil }
        self.init(context: context)
        self.name = name
        self.listId = Int64(listId)
        self.dueDate = dueDate
        self.isRecurring = isRecurring
        self.dayOfWeek = Int64(dayOfWeek)
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
            let dayOfWeek = listRepresentation.dayOfWeek,
            let isComplete = listRepresentation.isComplete else { return nil }
        let name = listRepresentation.name
        let dueDate = listRepresentation.dueDate
        let isRecurring = listRepresentation.isRecurring
        self.init(name: name, listId: Int64(listKey),
                  dueDate: dueDate, isRecurring: isRecurring,
                  dayOfWeek: Int64(dayOfWeek), isComplete: isComplete, context: context)
    }
    var listRepresentation: ListRepresentation? {
        guard let name = name,
        let dueDate = dueDate else { return nil }
        return ListRepresentation(name: name, dayOfWeek: Int(dayOfWeek),
                                  listId: Int(listId), isRecurring: isRecurring,
                                  dueDate: dueDate, isComplete: isComplete)
    }
}

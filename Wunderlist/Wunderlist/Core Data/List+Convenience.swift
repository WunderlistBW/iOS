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
// For segmented control and sections
enum ReminderType: String, CaseIterable {
    case daily
    case weekly
    case monthly
    case none
}
extension ListEntry: Persistable {
    convenience init?(name: String, isComplete: Bool? = false, days: Int64?, endOn:String?, isRepeated: Bool? = false, context: PersistentContext ) {
        guard let context = context as? NSManagedObjectContext, let isComplete = isComplete, let isRepeated = isRepeated, let days = days, let endOn = endOn
        else { return nil }
        self.init(context: context)
        self.name = name
        self.isComplete = isComplete
        self.days = Int64(days)
        self.endOn = endOn
        self.isRepeated = isRepeated
    }
    @discardableResult convenience init?(listRepresentation: ListRepresentation, context: PersistentContext) {
        guard let isComplete = listRepresentation.isComplete else { return nil }
        let name = listRepresentation.name
        
        self.init(name: name,
                  isComplete: isComplete,
            days: listRepresentation.days,
            endOn: listRepresentation.endOn,
            isRepeated: listRepresentation.isRepeated,
                  context: context)
    }
    var listRepresentation: ListRepresentation? {
        guard let name = name,
        let dueDate = dueDate else { return nil }
        return ListRepresentation(name: name, listId: Int(listId),
                                  dueDate: dueDate, isComplete: isComplete)
    }
}

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
    convenience init?(name: String, body: String?, completed: Bool? = false, recurring: String, dueDate: String, context: PersistentContext ) {
        
        guard let completed = completed, let body = body
        else { return nil }
        self.init(context: context)
        self.dueDate = dueDate
        self.name = name
        self.body = body
        self.completed = completed
        self.recurring = recurring
    }
    
    @discardableResult convenience init?(listRepresentation: ListRepresentation, context: PersistentContext) {
        guard let recurring = listRepresentation.recurring else { return nil }
        self.init(name: listRepresentation.name,
                  body: listRepresentation.body,
                  completed: listRepresentation.completed,
                  recurring: recurring,
                  dueDate: listRepresentation.dueDate,
                  context: context)
        
    }
    
    var listRepresentation: ListRepresentation? {
        guard let name = name,
            let recurring = recurring,
            let dueDate = dueDate else { return nil }
        return ListRepresentation(name: name,
                                  body: body,
                                  id: Int(id),
                                  dueDate: dueDate,
                                  completed: completed,
                                  recurring: recurring)
    }
}

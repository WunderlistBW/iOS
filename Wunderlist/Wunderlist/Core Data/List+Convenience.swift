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
    
    var listRepresentation: ListRepresentation? {
        guard let name = name, let listId = listId,
            let dueDate = dueDate else { return nil }
        return ListRepresentation(name: name,
                                  listId: listId.uuidString,
                                  dueDate: dueDate,
                                  isComplete: isComplete)
    }
    
    convenience init?(name: String, dueDate: Date? = Date(), isComplete: Bool? = false, listId: UUID, context: PersistentContext
    ) {
        guard let isComplete = isComplete
            else { return nil }
        self.init(context: context)
        self.name = name
        self.dueDate = dueDate
        self.isComplete = isComplete
        self.listId = listId
    }
    
    @discardableResult convenience init?(listRepresentation: ListRepresentation, context: PersistentContext) {
        
        guard let isComplete = listRepresentation.isComplete,
            let listId = listRepresentation.listId, let listIdString = UUID(uuidString: listId) else { return nil }
        let name = listRepresentation.name
        let dueDate = listRepresentation.dueDate
        self.init(name: name,
                  dueDate: dueDate,
                  isComplete: isComplete,
                  listId: listIdString,
                  context: context)
    }
    
    
}

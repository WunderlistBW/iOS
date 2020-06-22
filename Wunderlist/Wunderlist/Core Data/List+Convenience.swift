//
//  List+Convenience.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
import CoreData

extension ListEntry: Persistable {
    convenience init?(
        name: String,
        body: String,
        context: PersistentContext,
        timestamp: Date = Date(),
        identifier: UUID = UUID()
    ) {
        guard let context = context as? NSManagedObjectContext
            else { return nil }
        self.init(context: context)
        self.name = name
        self.body = body
        self.timestamp = timestamp
        self.identifier = identifier
    }
    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.calendar = .autoupdatingCurrent
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

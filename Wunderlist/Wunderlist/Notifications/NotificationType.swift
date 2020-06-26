//
//  NotificationType.swift
//  Wunderlist
//
//  Created by Nonye on 6/25/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

enum NotificationType: String, CaseIterable {
    case daily
    case weekly
    case monthly
    case never = ""
}

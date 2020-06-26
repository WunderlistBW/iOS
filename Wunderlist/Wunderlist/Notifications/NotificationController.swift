//
//  NotificationController.swift
//  Wunderlist
//
//  Created by Nonye on 6/25/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    let userNotificationCenter =  UNUserNotificationCenter.current()
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 84600, repeats: false)
    let calendar = Calendar.current
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private var date = Date()
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error:", error)
            }
        }
    }
    func triggerNotification(lists: ListRepresentation, notificationType: NotificationType, onDate date: Date, withId id: String) {
        switch notificationType {
        case .never:
            self.date = date
            var components = DateComponents()
            components.hour = 0
            components.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(lists: lists, notificationType: .never),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .daily:
            self.date = date
            var components = DateComponents()
            components.hour = 12
            components.minute = 30
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(lists: lists, notificationType: .daily),
                                                trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .weekly:
            self.date = date
            var weekComponents = DateComponents()
            weekComponents.weekday = calendar.component(.weekday, from: date)
            weekComponents.hour = 12
            weekComponents.minute = 30
            let notificationDate = weekComponents
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(lists: lists, notificationType: .weekly), trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
                
            }
        case .monthly:
            self.date = date
            var monthComponents = DateComponents()
            monthComponents.weekOfMonth = calendar.component(.weekOfMonth, from: date)
            monthComponents.weekday = calendar.component(.weekday, from: date)
            monthComponents.hour = 12
            monthComponents.minute = 30
            let notificationDate = monthComponents
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(lists: lists, notificationType: .monthly), trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func scheduleNotification(lists: ListRepresentation, notificationType: NotificationType) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default
        switch notificationType {
        case .daily:
            content.title = "\(lists.name)"
            content.body = "This is your daily reminder.\n\(lists.body)"
        case .weekly:
            content.title = "\(lists.name)"
            content.body = "This is your weekly reminder.\n\(lists.body)"
        case .never:
            content.title = "\(lists.name)"
            content.body = "\(lists.body)"
        case .monthly:
            content.title = "\(lists.name)"
            content.body = "This is your monthly reminder.\n\(lists.body)"
        }
        return content
    }
}

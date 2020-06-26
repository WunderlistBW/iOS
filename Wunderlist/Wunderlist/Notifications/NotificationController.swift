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
    var trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
    let calendar = Calendar.current
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private var date = Date()
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (_, error) in
            if let error = error {
                print("Error:", error)
            }
        }
    }
    func triggerNotification(lists: ListRepresentation, notificationType: NotificationType,
                             onDate date: Date, withId id: String) {
        switch notificationType {
        case .never:
            self.date = date
            let notificationTime = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
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
            let notificationTime = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
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
            let notificationTime = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(lists: lists,
                                                                              notificationType: .weekly), trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        case .monthly:
            self.date = date
            let notificationTime = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
            let identifier = id
            let request = UNNotificationRequest(identifier: identifier,
                                                content: scheduleNotification(lists: lists,
                                                                              notificationType: .monthly), trigger: trigger)
            userNotificationCenter.add(request) { (error) in
                print("notification: \(request.identifier)")
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    private func scheduleNotification(lists: ListRepresentation, notificationType: NotificationType)
        -> UNMutableNotificationContent {
            let content = UNMutableNotificationContent()
            content.sound = .default
            switch notificationType {
            case .daily:
                content.title = "\(lists.name)"
                content.body = "Daily reminder to: \(String(describing: lists.body))"
            case .weekly:
                content.title = "\(lists.name)"
                content.body = "Weekly reminder to: \(String(describing: lists.body))"
            case .monthly:
                content.title = "\(lists.name)"
                content.body = "Monthly reminder to: \(String(describing: lists.body))"
            case .never:
                content.title = "\(lists.name)"
                content.body = "\(String(describing: lists.body))"
            }
            return content
    }
}

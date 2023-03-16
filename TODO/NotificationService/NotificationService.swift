//
//  NotificationService.swift
//  TODO
//
//  Created by Artem Vavilov on 12.03.2023.
//

import UserNotifications

protocol NotificationServiceProtocol {
    func createNotification(taskName: String, date: Date, id: String)
    func deleteNotifications(with id: [String])
}

final class NotificationService {
    private let calendar = Calendar.current
    
    private func registerNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            else {
                print("notification center not authorized")
            }
        }
    }
}

extension NotificationService: NotificationServiceProtocol {
    func deleteNotifications(with id: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
    }
    
    func createNotification(taskName: String, date: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "Complete your TODO"
        content.subtitle = taskName
        content.sound = UNNotificationSound.default
        let dateComponents = calendar.dateComponents([.year, .day, .month, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        registerNotification(request: request)
    }
}

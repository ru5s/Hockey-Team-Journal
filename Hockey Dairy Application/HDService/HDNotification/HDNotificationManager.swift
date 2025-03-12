//
//  HDNotificationManager.swift
//  Hockey Team Journal
//
//  
//

import UIKit
import UserNotifications

class HDNotificationManager {
    
    static func requestAuthorization(completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("The user has allowed sending notifications")
                completion()
            } else {
                print("The user has forbidden sending notifications")
                completion()
            }
        }
    }
    
    static func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    static func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Successful registration to receive push notifications. Token: \(token)")
    }
    
    static func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register to receive push notifications: \(error.localizedDescription)")
    }
}

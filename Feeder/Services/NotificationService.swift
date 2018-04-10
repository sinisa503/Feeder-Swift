//
//  NotificationService.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 10/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService:NSObject {
   
   private override init(){}
   private let unCentar = UNUserNotificationCenter.current()
   
   static let shared = NotificationService()
   
   func authorize() {
      let options:UNAuthorizationOptions = [.sound,.badge,.alert]
      unCentar.requestAuthorization(options: options) {[unowned self] (authorized, error) in
         guard authorized else { return }
         self.configure()
      }
   }
   
   private func configure() {
      unCentar.delegate = self
   }
   
   func newStoryNotification(with interval:TimeInterval)  {
      let content = UNMutableNotificationContent()
      content.title = "News arrived"
      content.body = "You have new articles in your news feed"
      content.sound = .default()
      content.badge = 1
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
      
      let request = UNNotificationRequest(identifier: "userNotivfication-timer", content: content, trigger: trigger)
      
      unCentar.add(request, withCompletionHandler: nil)
   }
   
}

extension NotificationService: UNUserNotificationCenterDelegate {
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      completionHandler()
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
      let options:UNNotificationPresentationOptions = [.alert, .sound]
      completionHandler(options)
   }
}

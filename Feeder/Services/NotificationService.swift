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
   private let FEEDER_NOTIF_IDENTIFIER = "feederNotification"
   private let URL_NOTIF_KEY = "url"
   static let shared = NotificationService()
   
   func authorize() {
      let options:UNAuthorizationOptions = [.sound,.badge,.alert]
      unCentar.requestAuthorization(options: options) {(authorized, error) in
         guard authorized else { return }
         self.configure()
      }
   }
   
   private func configure() {
      unCentar.delegate = self
   }
   
   func newStoryNotification(with interval:TimeInterval, title:String = "News arrived", body:String = "You have new articles waiting")  {
      let content = UNMutableNotificationContent()
      content.title = title
      content.body = body
      content.sound = .default()
      content.badge = 1
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
      let request = UNNotificationRequest(identifier: FEEDER_NOTIF_IDENTIFIER, content: content, trigger: trigger)
      
      unCentar.add(request, withCompletionHandler: nil)
   }
   
   func newStoryNotification(stories: [StoryModel])  {
      //No more than two notifications in one fetch
      if stories.count <= 2 {
         for (index, story) in stories.enumerated() {
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = "TIMER_EXPIRED"
            content.title = story.title ?? "News arrived"
            content.body = story.text ?? "You have new articles waiting"
            content.userInfo = [URL_NOTIF_KEY:story.url ?? ""]
            content.sound = .default()
            content.badge = 1
            
            let timeInterval = TimeInterval(5 * (index + 1))
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval ,repeats: false)
            let request = UNNotificationRequest(identifier: "\(FEEDER_NOTIF_IDENTIFIER)\(index)", content: content, trigger: trigger)
            unCentar.add(request, withCompletionHandler: nil)
         }
      }else {
         let content = UNMutableNotificationContent()
         content.categoryIdentifier = "TIMER_EXPIRED"
         content.title = "News arrived!"
         content.body = "You have new articles waiting"
         content.sound = .default()
         content.badge = 1
         
         let timeInterval = TimeInterval(5)
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval ,repeats: false)
         let request = UNNotificationRequest(identifier: FEEDER_NOTIF_IDENTIFIER, content: content, trigger: trigger)
         unCentar.add(request, withCompletionHandler: nil)
      }
   }
}

extension NotificationService: UNUserNotificationCenterDelegate {
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      if response.notification.request.identifier.contains(FEEDER_NOTIF_IDENTIFIER) {
         if let url = response.notification.request.content.userInfo[URL_NOTIF_KEY] {
            print(url)
         }
      }
      completionHandler()
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
      let options:UNNotificationPresentationOptions = [.alert, .sound]
      completionHandler(options)
   }
}

//
//  AppDelegate.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      //Authorize notification
      NotificationService.shared.authorize()
      
      // Set initial view controller
      window = UIWindow(frame: UIScreen.main.bounds)
      let initialViewController = InitialListBuilder.buildInitialListModule()
      window?.rootViewController = initialViewController
      window?.makeKeyAndVisible()
      
      //Background refresh time
      UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
      
      return true
   }
   
   func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
      print(url.debugDescription)
      if url.absoluteString.starts(with: "feed:") {
         let feedUrl = String(url.absoluteString.dropFirst(5))
         if let _ = URL(string: feedUrl) {
            window = UIWindow(frame: UIScreen.main.bounds)
            let initialViewController = InitialListBuilder.buildInitialListModule(url: feedUrl)
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
         }
      }
      return true
   }
   
   func applicationWillEnterForeground(_ application: UIApplication) {
      //Remove badges from app icon
      UIApplication.shared.applicationIconBadgeNumber = 0
   }
   
   // Support for background fetch
   func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      if Reachability.isConnectedToNetwork(){
         let backgroundService = BackgroundService()
         backgroundService.checkUpdates(context: self.persistentContainer.viewContext)
         //Tell the system that background fetch is performed
         completionHandler(.newData)
      }else {
         completionHandler(.noData)
      }
   }


   func applicationWillTerminate(_ application: UIApplication) {
      self.saveContext()
   }

   // MARK: - Core Data stack
   lazy var persistentContainer: NSPersistentContainer = {

       let container = NSPersistentContainer(name: "Feeder")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {

               fatalError("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
   }()

   // MARK: - Core Data Saving support
   func saveContext () {
       let context = persistentContainer.viewContext
       if context.hasChanges {
           do {
               try context.save()
           } catch {
               let nserror = error as NSError
               fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
           }
       }
   }

}


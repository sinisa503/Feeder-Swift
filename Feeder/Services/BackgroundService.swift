//
//  BackgroundService.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 09/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData

class BackgroundService {
   
   private let parseManager = ParseManager()
   
   func checkForNewUpdates(context:NSManagedObjectContext) {
      let coreDataManager = CoreDataManager(context: context)
      if let allFeeds = coreDataManager.getAllFeeds() {
         for databaseFeed in allFeeds {
            guard let feedUrl = databaseFeed.url, let url = URL(string: feedUrl) else { continue }
            parseManager.parse(url: url) { refreshedFeed in
               guard let oldDate = databaseFeed.publishDate, let newDate = refreshedFeed?.publishDate else { return }
               if oldDate < newDate {
                  if let feed = refreshedFeed {
                     self.refreshFeed(feed: feed, context: context)
                  }
               }
            }
         }
      }
   }
   
   private func refreshFeed(feed:FeedModel,context:NSManagedObjectContext) {
      let coreDataManager = CoreDataManager(context: context)
      coreDataManager.refresh(feed: feed)
   }
}

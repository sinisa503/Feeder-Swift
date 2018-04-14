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
   
   /**Additional property refreshingFeed optional is only made
    for testing purpose and should only be called if making tests**/
   func checkUpdates(context:NSManagedObjectContext, refreshedFeed:FeedModel? = nil) {
      let coreDataManager = CoreDataManager(context: context)
      if let allFeeds = coreDataManager.getAllFeeds() {
         for databaseFeed in allFeeds {
            if let allStoriesIds = databaseFeed.stories?.allObjects as? [Story] {
               guard let feedUrl = databaseFeed.url, let url = URL(string: feedUrl) else { continue }
               let uniqueIds = allUniqueIdsFrom(stories: allStoriesIds)
               if refreshedFeed != nil {
                  if refreshedFeed?.uid == databaseFeed.uid {
                     store(refreshedFeed: refreshedFeed, uniqueIds: uniqueIds, for: databaseFeed, coreDataManager: coreDataManager)
                  }
               }else {
                  parseManager.parse(url: url) { refreshedFeed in
                     if refreshedFeed?.uid == databaseFeed.uid {
                        self.store(refreshedFeed: refreshedFeed, uniqueIds: uniqueIds, for: databaseFeed, coreDataManager: coreDataManager)
                     }
                  }
               }
            }
         }
      }
   }
   
   private func allUniqueIdsFrom(stories:[Story]) -> [String] {
      var uniqueIds:[String] = []
      for story in stories {
         if let uid = story.uid {
            uniqueIds.append(uid)
         }
      }
      return uniqueIds
   }
   
   private func store(refreshedFeed:FeedModel?, uniqueIds:[String], for databaseFeed:Feed,coreDataManager:CoreDataManager) {
      let newStories = refreshedFeed?.stories.filter({ (storyModel) -> Bool in
         if let uid = storyModel.uid {
            return !uniqueIds.contains(uid)
         }else {
            return false
         }
      })
      if let newStories = newStories, newStories.count > 0 {
         for story in newStories {
            coreDataManager.add(storyModel: story, for: databaseFeed)
         }
         sendNewStoryNotification(for: newStories, coreDataManger: coreDataManager)
      }
   }
   
   private func sendNewStoryNotification(for storyModels:[StoryModel], coreDataManger:CoreDataManager) {
      var feedDict:[Feed:String] = [:]
      for story in storyModels {
         if let uid = story.uid, let feed = coreDataManger.getFeedWith(uid: uid) {
            feedDict.updateValue(uid, forKey: feed)
         }
      }
      if feedDict.count == 1 {
         if let title = feedDict.first?.key.title, let uid = feedDict.first?.value {
            if let storyTitle = coreDataManger.getStory(withId: uid, or: nil)?.title {
               NotificationService.shared.newStoryNotification(with: 5.0, title: title, body: storyTitle)
            }else {
               NotificationService.shared.newStoryNotification(with: 5.0, title: title)
            }
         }
      }else if feedDict.count > 1 {
         NotificationService.shared.newStoryNotification(with: 5.0)
      }
   }
}










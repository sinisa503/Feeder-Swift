//
//  CoreDataManager.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 06/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
   
   func addNew(feedModel:FeedModel) {
      if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
         if let feed = Feed.addNew(feedModel: feedModel, context: context), feed.image == nil {
            if let urlString = feedModel.imageUrl, let url = URL(string: urlString) {
               let downloadService = DownloadService()
               downloadService.downloadImage(from: url) { data in
                  if let imageData = data {
                     self.add(imageData: imageData, for: feed, context: context)
                  }
               }
            }
         }
      }
   }
   
   func add(imageData:Data, for feed:Feed, context:NSManagedObjectContext) {
      feed.setValue(imageData, forKey: CoreDataConstant.FEED_IMAGE_PROPERTY)
      do {
         try context.save()
      } catch {
         //TODO: Handle error
      }
   }
   
   func getAllFeeds() -> [Feed]? {
      if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
         if let feeds = Feed.getAllFeeds(context: context) {
            for feed in feeds {
               print(feed.title)
               if let stories = feed.stories {
                  for story in stories {
                     if let story = story as? Story {
                        print(story.title)
                     }
                  }
               }
            }
         }
      }
      return nil
   }
}

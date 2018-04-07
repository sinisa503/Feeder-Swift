//
//  Feed+Functions.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 06/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData

extension Feed {
   
   
   /** Function checks if feed already exists using feed url. If it does function returns given feed and if not it creates new feed in database and returns that new feed **/
   static func addNew(feedModel:FeedModel,context:NSManagedObjectContext) -> Feed? {
      let request:NSFetchRequest<Feed> = Feed.fetchRequest()
      
      if let url = feedModel.url {
         request.predicate = NSPredicate(format: "url = %@", url)
      }
      
      do {
         //Check if feed with same url already exist and if it does return it instead create new one
         let feeds = try context.fetch(request)
         if let feed = feeds.first {
            return feed
         }else {
            if let newFeed = NSEntityDescription.insertNewObject(forEntityName: CoreDataConstant.ENTITY_FEED, into: context) as? Feed {
               
               newFeed.title = feedModel.title
               newFeed.descr = feedModel.descr
               newFeed.publishDate = feedModel.publishDate
               newFeed.url = feedModel.url
               
               if feedModel.stories.count > 0 {
                  for storyModel in feedModel.stories {
                     _ = Story.addNew(storyModel: storyModel, for: newFeed, context: context)
                  }
               }
               try context.save()
               return newFeed
            }
         }
      } catch _ {
         //TODO: Handle this error
         return nil
      }
      return nil
   }
   
   static func getAllFeeds(context: NSManagedObjectContext) -> [Feed]? {
      let request:NSFetchRequest<Feed> = Feed.fetchRequest()
      do {
         return try context.fetch(request)
      } catch _ {
         //TODO: Handle this error
         return nil
      }
   }
}
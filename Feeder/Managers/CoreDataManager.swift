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
   
   private let context:NSManagedObjectContext
   private let downloadService = DownloadService()
   
   init(context: NSManagedObjectContext) {
      self.context = context
   }
   
   func addNew(feedModel:FeedModel, success:(Bool)->()) {
         if let feed = Feed.addNew(feedModel: feedModel, context: context), feed.image == nil {
            
            //Initiate loading Feed image if there is one
            if let urlString = feedModel.imageUrl, let url = URL(string: urlString) {
               downloadService.downloadImage(from: url) { data in
                  if let imageData = data {
                     self.add(imageData: imageData, for: feed)
                  }
               }
            }
            
            //Initiate loading image for each story if there is one
            for story in feedModel.stories{
               if let imageUrl =  story.imageLink, let url = URL(string: imageUrl) {
                  if let storyDao = getStory(withId: story.url, or: story.title) {
                     downloadService.downloadImage(from: url) { data in
                        if let imageData = data {
                           self.add(imageData: imageData, for: storyDao)
                        }
                     }
                  }
               }
            }
            success(true)
         }
   }
   
   
   func add(imageData:Data, for story:Story) {
      story.setValue(imageData, forKey: CoreDataConstant.STORY_IMAGE_PROPERTY)
      do {
         try context.save()
      } catch {
         //TODO: Handle error
      }
   }
   
   func add(imageData:Data, for feed:Feed) {
      feed.setValue(imageData, forKey: CoreDataConstant.FEED_IMAGE_PROPERTY)
      do {
         try context.save()
      } catch {
         //TODO: Handle error
      }
   }
   
   func add(storyModel:StoryModel, for feed:Feed) {
       Story.addNew(storyModel: storyModel, for: feed, context: context)
   }
   
   func getStory(withId uid:String?, or title:String?) -> Story? {
      let request:NSFetchRequest<Story> = Story.fetchRequest()
      var predicate:NSPredicate?

      if let uid = uid {
         predicate = NSPredicate(format: "\(CoreDataConstant.UINIQE_ID_PROPERTY) == %@", uid)
      }
      request.predicate = predicate
      
      do {
         let results = try context.fetch(request)
         if results.count > 0 {
            return results.first
         }
      } catch  {
         //TODO: Handle error
      }
      return nil
   }
   
   func getFeedWith(uid:String?) -> Feed? {
      let request:NSFetchRequest<Feed> = Feed.fetchRequest()
      var predicate:NSPredicate?
      
      if let uid = uid {
         predicate = NSPredicate(format: "\(CoreDataConstant.UINIQE_ID_PROPERTY) == %@", uid)
      }
      request.predicate = predicate
      
      do {
         let results = try context.fetch(request)
         if results.count > 0 {
            return results.first
         }
      } catch  {
         //TODO: Handle error
      }
      return nil
   }
   
   func getAllFeeds() -> [Feed]? {
      if let feeds = Feed.getAllFeeds(context: context) {
         return feeds
      }else {
         return nil
      }
   }
   
   func deleteFeed(with uid: String) {
      let request:NSFetchRequest<Feed> = Feed.fetchRequest()
      let predicate = NSPredicate(format: "\(CoreDataConstant.UINIQE_ID_PROPERTY) == %@", uid)
      request.predicate = predicate
      
      do {
         let results = try context.fetch(request)
         if let firstFeed = results.first {
            context.delete(firstFeed)
         }
         try context.save()
      } catch let error {
         print("Error deleting a feed:\(error)")
      }
   }
   
   func deleteAllFeeds(context:NSManagedObjectContext) {
      let request:NSFetchRequest<Feed> = Feed.fetchRequest()
      do {
         let feeds = try context.fetch(request)
         for feed in feeds {
            context.delete(feed)
         }
         try context.save()
      } catch  {
         
      }
   }
}

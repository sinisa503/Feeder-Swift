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
   
   private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
   
   private let downloadService = DownloadService()
   func addNew(feedModel:FeedModel) {
      if let context = context {
         if let feed = Feed.addNew(feedModel: feedModel, context: context), feed.image == nil {
            
            //Initiate loading Feed image if there is one
            if let urlString = feedModel.imageUrl, let url = URL(string: urlString) {
               downloadService.downloadImage(from: url) { data in
                  if let imageData = data {
                     self.add(imageData: imageData, for: feed, context: context)
                  }
               }
            }
            
            //Initiate loading image for each story if there is one
            for story in feedModel.stories{
               if let imageUrl =  story.imageLink, let url = URL(string: imageUrl) {
                  if let storyDao = getStory(with: story.url, or: story.title, context: context) {
                     downloadService.downloadImage(from: url) { data in
                        if let imageData = data {
                           self.add(imageData: imageData, for: storyDao, context: context)
                        }
                     }
                  }
               }
            }
         }
      }
   }
   
   
   func add(imageData:Data, for story:Story, context:NSManagedObjectContext) {
      story.setValue(imageData, forKey: CoreDataConstant.STORY_IMAGE_PROPERTY)
      do {
         try context.save()
      } catch {
         //TODO: Handle error
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
   
   func getStory(with uid:String?, or title:String?, context:NSManagedObjectContext) -> Story? {
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
   
   func getAllFeeds() -> [Feed]? {
      if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
         if let feeds = Feed.getAllFeeds(context: context) {
            for feed in feeds {
               //print(feed.title)
               if let stories = feed.stories {
                  for story in stories {
                     if let story = story as? Story {
                        //print(story.title)
                     }
                  }
               }
            }
         }
      }
      return nil
   }
}

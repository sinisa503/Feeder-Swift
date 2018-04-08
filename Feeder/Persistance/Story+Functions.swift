//
//  Story+Functions.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 06/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
import CoreData

extension Story {
   
   /** Function checks if story already exists using title. If it does function returns given story and if not it creates new story in database and returns that new story **/
   static func addNew(storyModel:StoryModel,for feed: Feed, context:NSManagedObjectContext) -> Story? {
      let request:NSFetchRequest<Story> = Story.fetchRequest()
      
      if let uid = storyModel.uid {
         request.predicate = NSPredicate(format: "\(CoreDataConstant.UINIQE_ID_PROPERTY) = %@", uid)
      }
      
      do {
         //Check if story with same title already exist and if it does return it instead create new one
         let stories = try context.fetch(request)
         if let story = stories.first {
            return story
         }else {
            if let story = NSEntityDescription.insertNewObject(forEntityName: CoreDataConstant.ENTITY_STORY, into: context) as? Story {
               story.title = storyModel.title
               story.text = storyModel.text
               story.author = storyModel.author
               story.publishDate = storyModel.publishDate
               story.image = storyModel.image
               story.url = storyModel.url
               story.uid = storyModel.uid
               
               feed.addToStories(story)
            }
         }
      } catch _ {
         //TODO: Handle this error
         return nil
      }
      return nil
   }
}

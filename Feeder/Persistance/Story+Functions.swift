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
   
   static func addNew(storyModel:StoryModel,for feed: Feed, context:NSManagedObjectContext) {
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
}

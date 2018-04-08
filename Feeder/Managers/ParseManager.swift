//
//  ParseManager.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 06/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
import FeedKit


class ParseManager {
   
   private let coreDataManager = CoreDataManager()
   
   func parse(url: URL, success:@escaping (Bool)->())  {
      if let parser = FeedParser(URL: url) {
         parser.parseAsync { result in
            if !result.isSuccess {
               success(false)
            }else {
               self.parse(result)
            }
         }
      }else {
         success(false)
      }
   }
   
   private func parse(_ result:Result) {
      switch result {
      case .atom(let atomFeed) :
         parse(atomFeed)
      case .rss(let rssFeed) :
         parse(rssFeed)
      case .json(let jsonFeed) :
         parse(jsonFeed)
      case .failure(_) : break
      }
   }
   
   private func parse(_ atomFeed: AtomFeed) {
      let feedModel:FeedModel = FeedModel()
      
      feedModel.title = atomFeed.title
      feedModel.imageUrl = atomFeed.logo
      feedModel.descr = atomFeed.subtitle?.value
      feedModel.publishDate = atomFeed.updated
      feedModel.uid = atomFeed.id
      
      if let entries = atomFeed.entries {
         for entry in entries {
            let storyModel = StoryModel()
            storyModel.uid = entry.id
            storyModel.title = entry.title
            storyModel.author = entry.authors?.first?.name
            storyModel.publishDate = entry.published
            storyModel.text = entry.content?.value
            storyModel.url = entry.links?.first?.attributes?.href
            feedModel.stories.append(storyModel)
         }
         save(feedModel: feedModel)
      }
   }
   
   private func parse(_ rssFeed: RSSFeed) {
      let feedModel:FeedModel = FeedModel()
      feedModel.title = rssFeed.title
      feedModel.url = rssFeed.link
      feedModel.descr = rssFeed.description
      feedModel.publishDate = rssFeed.pubDate
      feedModel.imageUrl = rssFeed.image?.url
      feedModel.uid = UUID.init().uuidString
      
      if let items = rssFeed.items {
         for item in items {
            let storyModel = StoryModel()
            storyModel.uid = item.guid?.value
            storyModel.title = item.title
            storyModel.author = item.author
            storyModel.publishDate = item.pubDate
            storyModel.text = item.description
            storyModel.url = item.link
            feedModel.stories.append(storyModel)
         }
      }
      save(feedModel: feedModel)
   }
   
   private func parse(_ jsonFeed: JSONFeed) {
      let feedModel:FeedModel = FeedModel()
      feedModel.title = jsonFeed.title
      feedModel.url = jsonFeed.feedUrl
      feedModel.descr = jsonFeed.description
      feedModel.imageUrl = jsonFeed.icon
      feedModel.uid = jsonFeed.feedUrl
      
      if let items = jsonFeed.items {
         for item in items {
            let storyModel = StoryModel()
            storyModel.uid = item.id
            storyModel.title = item.title
            storyModel.author = item.author?.name
            storyModel.publishDate = item.datePublished
            storyModel.text = item.contentText
            storyModel.imageLink = item.image
            storyModel.url = item.url
            feedModel.stories.append(storyModel)
         }
      }
      save(feedModel: feedModel)
   }
   
   private func save(feedModel:FeedModel) {
      coreDataManager.addNew(feedModel: feedModel)
   }
}

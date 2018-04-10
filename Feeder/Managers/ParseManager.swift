//
//  ParseManager.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 06/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import FeedKit


class ParseManager {
   
   let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
   private var feedUrl:String?
   
   func parse(url: URL, success:@escaping (FeedModel?)->())  {
      feedUrl = url.absoluteString
      DispatchQueue.global(qos: .userInitiated).async {
         if let parser = FeedParser(URL: url) {
            parser.parseAsync { result in
               DispatchQueue.main.async {
                  if !result.isSuccess {
                     success(nil)
                  }else {
                     success(self.parse(result))
                  }
               }
            }
         }else {
            DispatchQueue.main.async {
               success(nil)
            }
         }
      }
   }
   
   private func parse(_ result:Result) -> FeedModel? {
      var feedModel:FeedModel?
      switch result {
      case .atom(let atomFeed) :
         feedModel = parse(atomFeed)
      case .rss(let rssFeed) :
         feedModel = parse(rssFeed)
      case .json(let jsonFeed) :
         feedModel = parse(jsonFeed)
      case .failure(_) :
         feedModel = nil
      }
      return feedModel
   }
   
   private func parse(_ atomFeed: AtomFeed) -> FeedModel {
      let feedModel:FeedModel = FeedModel()
      
      feedModel.title = atomFeed.title
      feedModel.imageUrl = atomFeed.logo
      feedModel.descr = atomFeed.subtitle?.value
      feedModel.publishDate = atomFeed.updated
      feedModel.uid = atomFeed.id
      feedModel.url = feedUrl
      
      if let entries = atomFeed.entries {
         for entry in entries {
            let storyModel = StoryModel()
            storyModel.uid = entry.id
            storyModel.title = entry.title
            storyModel.author = entry.authors?.first?.name
            storyModel.publishDate = entry.updated
            storyModel.text = entry.content?.value
            storyModel.url = entry.links?.first?.attributes?.href
            feedModel.stories.append(storyModel)
         }
      }
      return feedModel
   }
   
   private func parse(_ rssFeed: RSSFeed) -> FeedModel {
      let feedModel:FeedModel = FeedModel()
      feedModel.title = rssFeed.title
      feedModel.url = feedUrl
      feedModel.descr = rssFeed.description
      feedModel.publishDate = rssFeed.lastBuildDate
      feedModel.imageUrl = rssFeed.image?.url
      feedModel.uid = feedUrl
      
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
      return feedModel
   }
   
   private func parse(_ jsonFeed: JSONFeed) -> FeedModel {
      let feedModel:FeedModel = FeedModel()
      feedModel.title = jsonFeed.title
      feedModel.url = feedUrl
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
      return feedModel
   }
}

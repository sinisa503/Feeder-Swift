//
//  CoreDataTests.swift
//  FeederTests
//
//  Created by Sinisa Vukovic on 09/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import XCTest
import CoreData
@testable import Feeder

class CoreDataTests: XCTestCase {
   
   private var container: NSPersistentContainer?
   private var coreDataManager:CoreDataManager?
   private let testImageUrl = "https://homepages.cae.wisc.edu/~ece533/images/tulips.png"
   private var backgroundService:BackgroundService?
   
   override func setUp() {
      super.setUp()
      
      container = NSPersistentContainer.testContainer()
      if let container = container{
         coreDataManager = CoreDataManager(context: container.viewContext)
      }
      backgroundService = BackgroundService()
   }
   
   override func tearDown() {

      container = nil
      backgroundService = nil
      coreDataManager = nil

      super.tearDown()
   }
   
   
   //MARK: Test functions
   func testRemovingAllObjectsFromDatabase() {
      guard let coreDataManager = coreDataManager else {
         XCTFail()
         return
      }
      deleteAllFeedsFromDatabase()
      //At this point feed count should be 0
      XCTAssertEqual(coreDataManager.getAllFeeds()?.count, 0)
      for index in 0..<3 {
         let testFeedModel = constructFeedModel(number: index)
         storeToDatabase(feedModel: testFeedModel)
      }
      XCTAssertEqual(coreDataManager.getAllFeeds()?.count, 3)
      deleteAllFeedsFromDatabase()
      XCTAssertEqual(coreDataManager.getAllFeeds()?.count, 0)
   }
   
   func testAddingNewFeedToDataBase() {
      guard let coreDataManager = coreDataManager else {
         XCTFail()
         return
      }
      deleteAllFeedsFromDatabase()
      XCTAssertEqual(coreDataManager.getAllFeeds()?.count, 0)
      let testFeedModel1 = constructFeedModel(number: 1)
      storeToDatabase(feedModel: testFeedModel1)
      XCTAssertEqual(coreDataManager.getAllFeeds()?.count, 1)
      if let feed = coreDataManager.getAllFeeds()?.first {
         XCTAssertEqual(testFeedModel1.title, feed.title)
         XCTAssertEqual(testFeedModel1.descr, feed.descr)
         XCTAssertEqual(testFeedModel1.publishDate, feed.publishDate)
         XCTAssertEqual(testFeedModel1.uid, feed.uid)
         XCTAssertEqual(testFeedModel1.url, feed.url)
      }else {
         XCTFail("Error fetching feeds from Core Data")
      }
   }
   
   func testDeletingFeed() {
      guard let coreDataManager = coreDataManager else {
         XCTFail()
         return
      }
      deleteAllFeedsFromDatabase()
      let testFeedModel1 = constructFeedModel(number: 1)
      storeToDatabase(feedModel: testFeedModel1)
      if let feeds = coreDataManager.getAllFeeds() {
         XCTAssertEqual(feeds.count, 1)
      }else {
         XCTFail("Error fetching feeds from Core Data")
      }
      if let uid = testFeedModel1.uid {
         coreDataManager.deleteFeed(with: uid)
      }else {
         XCTFail()
      }
      if let allFeeds = coreDataManager.getAllFeeds() {
         XCTAssertEqual(allFeeds.count, 0)
      }else {
         XCTFail()
      }
   }
   
   func testAddingImageToCoreData() {
      guard let coreDataManager = coreDataManager else {
         XCTFail()
         return
      }
      deleteAllFeedsFromDatabase()
      let testFeedModel1 = constructFeedModel(number: 1)
      storeToDatabase(feedModel: testFeedModel1)
      if let feed = coreDataManager.getAllFeeds()?.first {
         XCTAssertNil(feed.image,"Image already exists when it should not!")
         if let data = UIImagePNGRepresentation(UIImage(named: "mountain")!) {
            coreDataManager.add(imageData: data, for: feed)
         }
         XCTAssertNotNil(feed.image, "Image not saved to database")
      }else {
         XCTFail("Stored feed not found!")
      }
   }
   
   func testRefreshingFeeds() {
      guard let coreDataManager = coreDataManager, let backgroundService = backgroundService, let context = container?.viewContext  else {
         XCTFail()
         return
      }
      deleteAllFeedsFromDatabase()
      let testFeedModel1 = constructFeedModel(number: 1)
      let testFeedModel2 = constructFeedModel(number: 2)
      storeToDatabase(feedModel: testFeedModel1)
      storeToDatabase(feedModel: testFeedModel2)
      XCTAssertEqual(coreDataManager.getAllFeeds()?.count, 2)
      if let feedsInDataBase = coreDataManager.getAllFeeds() {
         XCTAssertNotNil(feedsInDataBase[0])
         XCTAssertNotNil(feedsInDataBase[1])
         XCTAssertEqual(feedsInDataBase[0].stories?.count, 5)
         XCTAssertEqual(feedsInDataBase[1].stories?.count, 5)
         
         testFeedModel1.stories.append(contentsOf: getTest2ArrayOfStories())
         //In test feed model 1 now there are 10 stories but only three are new stories
         XCTAssertEqual(testFeedModel1.stories.count, 10)
         backgroundService.checkUpdates(context: context, refreshedFeed: testFeedModel1)
      }else {
         XCTFail("No feeds in Database")
      }
      
      if let allFeeds = coreDataManager.getAllFeeds() {
         XCTAssertEqual(allFeeds.count, 2)
         XCTAssertNotNil(allFeeds[0])
         XCTAssertNotNil(allFeeds[1])
         
         //First feed should have additional 3 stories now - second should contain same as before
         if let firstFeed = coreDataManager.getFeedWith(uid:testFeedModel1.uid) {
            XCTAssertEqual(firstFeed.stories?.count, 8)
         }else {
            XCTFail("No feed found")
         }
         if let secondFeed = coreDataManager.getFeedWith(uid:testFeedModel2.uid) {
            XCTAssertEqual(secondFeed.stories?.count, 5)
         }else {
            XCTFail("No feed found")
         }
      }
   }
   
   //MARK: Helper functions
   private func deleteAllFeedsFromDatabase() {
      guard let coreDataManager = coreDataManager else {
         XCTFail()
         return
      }
      if let context = container?.viewContext {
         coreDataManager.deleteAllFeeds(context: context)
      }
   }
   
   private func storeToDatabase(feedModel:FeedModel) {
      guard let coreDataManager = coreDataManager else {
         XCTFail()
         return
      }
      coreDataManager.addNew(feedModel: feedModel)
   }
   
   private func constructFeedModel(number:Int, imageUrl:String? = nil) -> FeedModel {
      let testFeedModel = FeedModel()
      testFeedModel.title = "Model\(number) Title"
      testFeedModel.descr = "Model\(number) Desc"
      testFeedModel.imageUrl = imageUrl
      testFeedModel.publishDate = Date()
      testFeedModel.uid = "testModel\(number)UniqueIdString"
      testFeedModel.url = "model\(number)TestUrl"
      testFeedModel.stories = getTestArrayOfStories()
      
      return testFeedModel
   }
   
   private func getTestArrayOfStories()->[StoryModel] {
      let testStoryModel1:StoryModel = StoryModel()
      let testStoryModel2:StoryModel = StoryModel()
      let testStoryModel3:StoryModel = StoryModel()
      let testStoryModel4:StoryModel = StoryModel()
      let testStoryModel5:StoryModel = StoryModel()
      
      let arrayOfStoryModels:[StoryModel] = [testStoryModel1,testStoryModel2,testStoryModel3,testStoryModel4,testStoryModel5]
      
      for (index,story) in arrayOfStoryModels.enumerated() {
         let title = "Test Title: \(index)"
         let publishDate = Date()
         let imageLink = "https://www.agnosticdev.com/sites/default/files/2017-11/latency_output.png"
         let text = "Some testing text for story model number : \(index)"
         let uniqueId = "SomeUinqueIdNumber:\(index)"
         
         story.title = title
         story.publishDate = publishDate
         story.imageLink = imageLink
         story.text = text
         story.uid = uniqueId
      }
      
      return arrayOfStoryModels
   }
   
   private func getTest2ArrayOfStories()->[StoryModel] {
      let testStoryModel1:StoryModel = StoryModel()
      let testStoryModel2:StoryModel = StoryModel()
      let testStoryModel3:StoryModel = StoryModel()
      let testStoryModel4:StoryModel = StoryModel()
      let testStoryModel5:StoryModel = StoryModel()
      
      let arrayOfStoryModels:[StoryModel] = [testStoryModel1,testStoryModel2,testStoryModel3,testStoryModel4,testStoryModel5]
      
      for (index,story) in arrayOfStoryModels.enumerated() {
         let title = "Test Title: \(index * index)"
         let publishDate = Date()
         let imageLink = "https://www.agnosticdev.com/sites/default/files/2017-11/latency_output.png"
         let text = "Some testing text for story model number : \(index * index)"
         
         let uniqueId:String?
         //Three additional stories will have different uniqueId
         if index % 2 == 0 {
            uniqueId = "SomeUinqueIdNumber:\(index + 100)"
         }else {
            uniqueId = "SomeUinqueIdNumber:\(index)"
         }
         
         story.title = title
         story.publishDate = publishDate
         story.imageLink = imageLink
         story.text = text
         story.uid = uniqueId
      }
      
      return arrayOfStoryModels
   }
}
extension NSPersistentContainer {
   
   class func testContainer() -> NSPersistentContainer {
      let container = NSPersistentContainer(name: "Feeder")
      let persistentStoreDescription = NSPersistentStoreDescription()
      persistentStoreDescription.type = NSInMemoryStoreType
      
      container.persistentStoreDescriptions = [persistentStoreDescription]
      container.loadPersistentStores { (storeDescription, error) in
         if let error = error {
            fatalError("\(error.localizedDescription)")
         }
      }
      container.viewContext.automaticallyMergesChangesFromParent = true
      return container
   }
}

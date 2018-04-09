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
   private let testFeedModel1:FeedModel = FeedModel()
   
   override func setUp() {
      super.setUp()
      
      container = NSPersistentContainer.testContainer()
      if let container = container{
         coreDataManager = CoreDataManager(context: container.viewContext)
      }
      

      testFeedModel1.title = "Model1 Title"
      testFeedModel1.descr = "Model1 Desc"
      testFeedModel1.imageUrl = "https://www.agnosticdev.com/sites/default/files/2017-11/latency_output.png"
      testFeedModel1.publishDate = Date()
      testFeedModel1.uid = "testModel1UniqueIdString"
      testFeedModel1.url = "model1TestUrl"
      testFeedModel1.stories = getTestArrayOfStories()
   }
   
   override func tearDown() {
      
      container = nil
      
      super.tearDown()
   }
   
   func testAddingNewFeedToDataBase() {
      guard let coreDataManager = coreDataManager else {
         XCTFail()
         return
      }
      coreDataManager.addNew(feedModel: testFeedModel1)
      
      if let model = coreDataManager.getAllFeeds()?.first {
         XCTAssertEqual(model.title, testFeedModel1.title)
      }
   }
   
   func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
         // Put the code you want to measure the time of here.
      }
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
   
//   func testAddingImageToCoreData() {
//      if let data = UIImagePNGRepresentation(UIImage(named: "mountain")!) {
//         let manager = CoreDataManager()
//         if let feed = fetchedResultsController?.fetchedObjects?.last {
//            manager.add(imageData: data, for: feed, context: (fetchedResultsController?.managedObjectContext)!)
//         }
//      }
//   }
   
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

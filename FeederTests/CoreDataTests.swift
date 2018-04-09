//
//  CoreDataTests.swift
//  FeederTests
//
//  Created by Sinisa Vukovic on 09/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import XCTest
@testable import Feeder

class CoreDataTests: XCTestCase {
   
   override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
   }
   
   override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
   }
   
   func testExample() {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
   }
   
   func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
         // Put the code you want to measure the time of here.
      }
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

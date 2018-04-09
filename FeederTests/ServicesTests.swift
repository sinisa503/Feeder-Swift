//
//  FeederTests.swift
//  FeederTests
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import XCTest
@testable import Feeder

class ServicesTests: XCTestCase {
   
   private var downloadService:DownloadService?
   private let testImageUrl = "https://homepages.cae.wisc.edu/~ece533/images/tulips.png"
    
    override func setUp() {
        super.setUp()
      
      downloadService = DownloadService()
    }
    
    override func tearDown() {
        downloadService = nil
        super.tearDown()
    }
    
    func testDownloadImageFromWeb() {
      if let downloadService = downloadService {
         if let url = URL(string: testImageUrl) {
         let expecation = expectation(description: "Expected load imagefrom web")
            downloadService.downloadImage(from: url) { data in
               expecation.fulfill()
               XCTAssertNotNil(data,"No data downloaded")
            }
            waitForExpectations(timeout: 5.0,handler:nil)
         }else {
            XCTFail("URL not valid")
         }
      }else {
         XCTFail("Download service is nil")
      }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

//
//  FeedViewModel.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

class FeedModel {
   
   var title: String?
   var url: String?
   var imageUrl: String?
   var descr: String?
   var publishDate: Date?
   var stories: [StoryModel] = []
   var uid:String?
}

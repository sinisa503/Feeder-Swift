//
//  InitialListUseCase.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
protocol FeedListUseCase: UseCase {
   
   func saveFeed(url:String)
   func deleteFeed(uid:String)
}

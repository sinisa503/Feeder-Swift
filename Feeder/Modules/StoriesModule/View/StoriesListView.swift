//
//  StoriesListView.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

protocol StoriesListView: ViewPresentation {
   
   var presenter: FeedListPesentation? { get set }
}

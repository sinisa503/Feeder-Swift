//
//  InitialListPewsentation.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

protocol FeedListPesentation: ViewPresentation {
   
   //Interactor
   func saveFeed(url:String)
   
   //Router
   func show(storiesVC: StoriesListViewController)
   
   //View
   func showErrorAlert()
   func showNoNetworkAlert()
}

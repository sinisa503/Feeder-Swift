//
//  InitialListInteractor.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

class FeedListInteractor: FeedListUseCase {
   var presenter: FeedListPesentation?
   
    func saveFeed(url:String) {
      let parseManager = ParseManager()
      if let feedURL = URL(string: url) {
         parseManager.parse(url: feedURL) {[weak self] success in
            if !success {
               self?.presenter?.showErrorAlert()
            }
         }
      }
   }
}

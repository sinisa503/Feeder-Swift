//
//  InitialListInteractor.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class FeedListInteractor: FeedListUseCase {
   var presenter: FeedListPesentation?
   
   let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
   
    func saveFeed(url:String) {

      let parseManager = ParseManager()
      if let feedURL = URL(string: url) {
         parseManager.parse(url: feedURL) {[weak self] feedModel in
            if let feedModel = feedModel {
               if let context = self?.context {
                  let coreDataManager = CoreDataManager(context: context)
                  coreDataManager.addNew(feedModel: feedModel)
               }
            }else {
               self?.presenter?.showErrorAlert()
            }
         }
      }
   }
   
   func deleteFeed(uid:String) {
      if let context = context {
         let coreDataManager = CoreDataManager(context: context)
         coreDataManager.deleteFeed(with: uid)
      }
   }
}

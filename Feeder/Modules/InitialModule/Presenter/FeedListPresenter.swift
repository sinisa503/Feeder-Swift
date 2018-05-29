//
//  InitialListPresenter.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class FeedListPresenter: FeedListPesentation {
   var viewController: FeedListView?
   var router: FeedListWireframe?
   var interactor:FeedListUseCase?
   
   func viewDidLoad() {
      
   }
   
   func viewWillApear() {
      
   }
   
   func viewWillDisapear() {
      
   }
   
   func show(storiesVC: StoriesListViewController) {
      router?.show(storiesVC: storiesVC)
   }
   
   func saveFeed(url:String) {
      interactor?.saveFeed(url: url)
   }
   
   func deleteFeed(uid:String) {
      interactor?.deleteFeed(uid: uid)
   }
   
   func showErrorAlert(title:String, message:String) {
      viewController?.showErrorAlert(title:title, message:message)
   }
   func showNoNetworkAlert() {
      viewController?.showNoNetworkAlert()
   }
   func showToast(message:String) {
      viewController?.showToast(message: message)
   }
}

//
//  InitialListBuilder.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class InitialListBuilder {
   
   static func buildInitialListModule(url: String? = nil) -> UIViewController {
      
      let navigationController = UINavigationController()
      let viewController = FeedListViewController()
      let presenter = FeedListPresenter()
      let router = FeedListRouter()
      let interactor = FeedListInteractor()
      
      viewController.presenter = presenter
      viewController.url = url
      presenter.viewController = viewController
      presenter.router = router
      presenter.interactor = interactor
      router.viewController = viewController
      interactor.presenter = presenter
      
      navigationController.setViewControllers([viewController], animated: true)
      
      return navigationController
   }
}

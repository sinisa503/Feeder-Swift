//
//  StoriesListBuilder.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class StoriesListBuilder {
   
   static func buildInitialListModule(with listOfStories:[Story]) -> StoriesListViewController? {

      let storiesStoryboard = UIStoryboard(name: Constant.STORIES_STORYBOARD_NAME, bundle: nil)
      
      if let storiesListVC = storiesStoryboard.instantiateViewController(withIdentifier: Constant.STORIES_LIST_CONTROLLER_IDENTIFIER) as? StoriesListViewController {
       
         
         let presenter = StoriesListPresenter()
         let router = StoriesListRouter()
         let interactor = StoriesListInteractor()
         
         
         storiesListVC.presenter = presenter
         presenter.viewController = storiesListVC
         presenter.router = router
         router.viewController = storiesListVC
         interactor.presenter = presenter
         
         storiesListVC.listOfStories.value = listOfStories
         
         return storiesListVC
      }
      return nil
   }
}

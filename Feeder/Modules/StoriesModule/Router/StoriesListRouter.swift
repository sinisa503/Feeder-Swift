//
//  StoriesListRouter.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class StoriesListRouter: StoriesListWireframe {
   var viewController: UIViewController?
   
   func showStory() {
      if let storiesListViewController = viewController as? StoriesListViewController {
         storiesListViewController.showStory()
      }
   }
}

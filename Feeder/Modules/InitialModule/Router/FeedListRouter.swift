//
//  InitialListRouter.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class FeedListRouter: FeedListWireframe {
   var viewController: UIViewController?
   
   
   func show(storiesVC: StoriesListViewController) {
      self.viewController?.navigationController?.pushViewController(storiesVC, animated: true)
   }
}

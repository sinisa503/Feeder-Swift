//
//  StoriesListPresenter.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class StoriesListPresenter: StoriesListPresentation {
   
   weak var viewController: UIViewController?
   var router: StoriesListWireframe?
   
   func viewDidLoad() {
      
   }
   
   func viewWillApear() {
      
   }
   
   func viewWillDisapear() {
      
   }
   
   func showStory() {
      router?.showStory()
   }
}

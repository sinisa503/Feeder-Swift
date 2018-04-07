//
//  StoriesListViewController.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class StoriesListViewController: UIViewController {
   
   var presenter: StoriesListPresentation?
   var listOfStories:[Story]?
   
   @IBOutlet weak var tableView: UITableView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   
}

extension StoriesListViewController: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return listOfStories?.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.STORIES_TABLE_VIEW_CELL_IDENTIFIER) as? StoryListTableViewCell {
         if let listOfStories = listOfStories {
            cell.configure(with: listOfStories[indexPath.row])
         }
         return cell
      }else {
         return UITableViewCell()
      }
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
   }
   
}

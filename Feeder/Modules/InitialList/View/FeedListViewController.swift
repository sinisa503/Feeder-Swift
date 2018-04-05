//
//  ViewController.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit


class FeedListViewController: UITableViewController {

   var presenter: FeedListPesentation?
   
   //MARK: ViewController lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      presenter?.viewDidLoad()
      tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: Constant.FeedTableViewCellIdentifier)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      presenter?.viewWillApear()
      
      setUpNavigationBar()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      presenter?.viewWillDisapear()
   }
   
   //MARK: Private functions
   private func setUpNavigationBar() {
      navigationController?.navigationBar.topItem?.title = Constant.NEWS_TITLE
      navigationController?.navigationBar.tintColor = UIColor.black
      navigationController?.navigationBar.barTintColor = Theme.NAVIGATION_BAR_LIME

      let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add , target: self, action: #selector(addNewFeed(_:)))
      navigationController?.navigationBar.topItem?.rightBarButtonItem = rightBarButton
   }

   @objc private func addNewFeed(_ sender: UIBarButtonItem) {
      let actionViewController = UIAlertController(title: "Add Feed", message: "", preferredStyle: UIAlertControllerStyle.alert)
      actionViewController.addTextField { textField in
         textField.placeholder = "Enter name"
      }
      actionViewController.addTextField { textField in
         textField.placeholder = "Enter url"
      }
      
      actionViewController.addAction(UIAlertAction(title: "Save", style: .default , handler: { (action) in
         if let nameTextField = actionViewController.textFields?[0], let text = nameTextField.text{
            print(text)
         }
         if let urlTextField = actionViewController.textFields?[1], let text = urlTextField.text {
            print(text)
         }
      }) )
      
      self.present(actionViewController, animated: true, completion: nil)
   }
   
   //MARK: TableView Delegate & Datasource
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.FeedTableViewCellIdentifier, for: indexPath) as? FeedTableViewCell {
         
         
         let defaultViewModel = FeedViewModel(title: Constant.DEFAULT_TITLE, story: Constant.DEFAULT_NEWS, image: Constant.DEFAULT_IMAGE_NAME)
         cell.configureCell(with: defaultViewModel)
         
         return cell
      }else {
         return UITableViewCell()
      }
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 12
   }
   
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return Constant.cellHeight
   }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
   }
}


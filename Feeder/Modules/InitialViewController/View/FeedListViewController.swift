//
//  ViewController.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData


class FeedListViewController: UITableViewController {

   var presenter: FeedListPesentation?
   fileprivate var fetchedResultsController:NSFetchedResultsController<Feed>?
   
   //MARK: ViewController lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      presenter?.viewDidLoad()
      tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: Constant.FeedTableViewCellIdentifier)
      
      setFetchedResultsController()
      
   }
   
   func testAddingImageToCoreData() {
      if let data = UIImagePNGRepresentation(UIImage(named: "mountain")!) {
         let manager = CoreDataManager()
         if let feed = fetchedResultsController?.fetchedObjects?.last {
            manager.add(imageData: data, for: feed, context: (fetchedResultsController?.managedObjectContext)!)
         }
      }
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
   
   private func setFetchedResultsController() {
      let feedRequest:NSFetchRequest<Feed> = Feed.fetchRequest()
      let sortDescriptorDate = NSSortDescriptor(key: CoreDataConstant.FEED_SORT_DESCRIPTOR_PUBLISH_DATE, ascending: true)
      feedRequest.sortDescriptors = [sortDescriptorDate]
      if let delegate = UIApplication.shared.delegate as? AppDelegate {
         let context = delegate.persistentContainer.viewContext
         fetchedResultsController = NSFetchedResultsController(fetchRequest: feedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "feedCache")
         fetchedResultsController?.delegate = self
         do {
            try fetchedResultsController?.performFetch()
         }catch let error {
            print("Error fetching from CoreData: \(error.localizedDescription)")
         }
      }
   }
   
   private func setUpNavigationBar() {
      navigationController?.navigationBar.topItem?.title = Constant.NEWS_TITLE
      navigationController?.navigationBar.tintColor = UIColor.black
      navigationController?.navigationBar.barTintColor = Theme.NAVIGATION_BAR_LIME

      let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add , target: self, action: #selector(addNewFeed(_:)))
      navigationController?.navigationBar.topItem?.rightBarButtonItem = rightBarButton
   }

   @objc private func addNewFeed(_ sender: UIBarButtonItem) {
      let actionViewController = UIAlertController(title: "Add new feed", message: "", preferredStyle: UIAlertControllerStyle.alert)
      actionViewController.addTextField { textField in
         textField.placeholder = "Enter url"
      }
      
      actionViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
      
      actionViewController.addAction(UIAlertAction(title: "Save", style: .default , handler: { (action) in
         if let urlTextField = actionViewController.textFields?.first, let url = urlTextField.text {
            self.saveFeed(url: url)
         }
      }) )
      self.present(actionViewController, animated: true, completion: nil)
   }
   
   private func saveFeed(url:String) {
      let parseManager = ParseManager()
      if let feedURL = URL(string: url) {
         parseManager.parse(url: feedURL) { success in
            if !success {
               print("Not possible to parse feed url!")
            }
         }
      }
   }
   
   //MARK: TableView Delegate & Datasource
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.FeedTableViewCellIdentifier, for: indexPath) as? FeedTableViewCell {
         
//         let defaultViewModel = FeedViewModel(title: Constant.DEFAULT_TITLE, story: Constant.DEFAULT_NEWS, image: Constant.DEFAULT_IMAGE_NAME)
//         cell.configureCell(with: defaultViewModel)
         if let feed = fetchedResultsController?.object(at: indexPath) {
            cell.configureCell(with: feed)
         }
         
         return cell
      }else {
         return UITableViewCell()
      }
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return fetchedResultsController?.fetchedObjects?.count ?? 0
   }
   
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return Constant.cellHeight
   }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

   }
}

extension FeedListViewController : NSFetchedResultsControllerDelegate {
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

      tableView.reloadData()
   }
}


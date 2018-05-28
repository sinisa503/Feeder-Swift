//
//  StoriesListViewController.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StoriesListViewController: UIViewController {
   
   var presenter: StoriesListPresentation?
   var listOfStories:Variable<[Story]> = Variable([])
   private let disposeBag = DisposeBag()
   
   private var selectedStoryUrl:String?
   
   @IBOutlet weak var tableView: UITableView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      sortStories()
      setupCellConfiguration()
      setUpTableRowTap()
   }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let webViewController = segue.destination as? WebViewViewController {
         webViewController.url = selectedStoryUrl
      }
    }
   
   private func setupCellConfiguration() {
      listOfStories.asObservable().bind(to: tableView.rx
         .items(cellIdentifier: StoryListTableViewCell.IDENTIFIER,
                cellType: StoryListTableViewCell.self)) { row,story,cell in
            cell.configure(with: story)
      }
      .disposed(by: disposeBag)
   }
   
   private func setUpTableRowTap() {
      tableView.rx.modelSelected(Story.self)
         .subscribe(onNext: {[weak self] story in
            if let url = story.url {
               self?.selectedStoryUrl = url
               self?.presenter?.showStory()
            }
            if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
               self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
         })
         .disposed(by: disposeBag)
   }
   
   private func sortStories() {
      listOfStories.value.sort { (firstStory, secondStory) -> Bool in
         guard let firstDate = firstStory.publishDate, let secondDate = secondStory.publishDate else { return true }
         return firstDate > secondDate
      }
   }
   
   func showStory() {
      performSegue(withIdentifier: Constant.SHOW_STORY_SEGUEI, sender: self)
   }
}

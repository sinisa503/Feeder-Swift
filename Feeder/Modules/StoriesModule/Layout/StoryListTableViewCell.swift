//
//  StoryListTableViewCell.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class StoryListTableViewCell: UITableViewCell {
   
   @IBOutlet weak var storyImage: UIImageView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   
   @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
   
   func configure(with story:Story) {
      titleLabel.text = story.title != nil ? story.title : ""

      if let date = story.publishDate {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MM/dd/yyyy"
         let dateString = dateFormatter.string(from: date)
         dateLabel.text = dateString
      }else {
         dateLabel.text = ""
      }
      
      //Use image for specific story if there is one
      if let imageData = story.image {
         if let image = UIImage(data: imageData) {
            storyImage.image = image
            imageWidthConstraint.constant = image.size.width
         }
         //If not use image from feed if there is one
      }else {
         if let imageData = story.feed?.image {
            if let image = UIImage(data: imageData) {
               storyImage.image = image
               imageWidthConstraint.constant = image.size.width
            }
         }
      }
   }

}

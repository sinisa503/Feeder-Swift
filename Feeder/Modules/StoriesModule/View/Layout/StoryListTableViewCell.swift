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
   @IBOutlet weak var descriptionLabel: UILabel!
   @IBOutlet weak var authorLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
   
   func configure(with story:Story) {
      if let title = story.title {
         titleLabel.text = title
      }
      if let data = story.image {
         storyImage.image = UIImage(data: data)
      }
      if let description = story.text {
         descriptionLabel.text = description
      }
      if let author = story.author {
         authorLabel.text = author
      }
      if let date = story.publishDate {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd.mm.yy"
         let dateString = dateFormatter.string(from: date)
         dateLabel.text = dateString
      }
   }

}

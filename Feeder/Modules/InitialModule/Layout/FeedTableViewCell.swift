//
//  InitialListTableViewCell.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
   
   private var storyImageView:UIImageView = UIImageView()
   private var storyTextView: UILabel = UILabel()
   private var storyTitleView: UILabel = UILabel()
   
   var imageWidthConstriant:NSLayoutConstraint?
   let imageViewWidth:CGFloat = Constant.cellHeight * 0.6

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: Constant.FEED_TABLE_VIEW_CELL_IDENTIFIER)
      setUpOutlets()
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
   
   public func configureCell(with model:Feed) {
      if let imageData = model.image {
         storyImageView.image = UIImage(data: imageData)
         UIView.animate(withDuration: 1.0) { [unowned self] in
            self.imageWidthConstriant?.constant = self.imageViewWidth
         }
      }
      storyTitleView.text = model.title
      storyTextView.text = model.descr
   }
   
   private func setUpOutlets() {
      addStoryImageView()
      addStoryLabels()
   }
   
   private func addStoryImageView() {
      
      self.addSubview(storyImageView)
      self.bringSubview(toFront: storyImageView)
      storyImageView.translatesAutoresizingMaskIntoConstraints = false
      
      let imageCenterConstriant = NSLayoutConstraint(item: storyImageView, attribute: .centerY, relatedBy: .equal , toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
      let leadingImageConstriant = NSLayoutConstraint(item: storyImageView, attribute: .leading , relatedBy: .equal , toItem: self, attribute: .leading, multiplier: 1.0, constant: 8.0)
      imageWidthConstriant = NSLayoutConstraint(item: storyImageView, attribute: .width, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
      let imageHeightConstriant = NSLayoutConstraint(item: storyImageView, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 1.0, constant: imageViewWidth)
      
      self.addConstraints([imageCenterConstriant, imageHeightConstriant, leadingImageConstriant, imageWidthConstriant!])
      
      
      storyImageView.layer.cornerRadius = 8.0
      storyImageView.layer.masksToBounds = true
      storyImageView.contentMode = .scaleAspectFit
      storyImageView.backgroundColor = UIColor.clear
   }
   
   private func addStoryLabels() {
      let verticalStack = UIStackView()
      verticalStack.axis = .vertical
      verticalStack.alignment = .fill
      verticalStack.distribution = .fillProportionally

      storyTitleView.font = Theme.HELVETICA_BOLD
      storyTitleView.textAlignment = .center
      storyTitleView.adjustsFontSizeToFitWidth = true
      storyTitleView.numberOfLines = 2
      storyTitleView.minimumScaleFactor = CGFloat(0.5)
      
      storyTextView.font = Theme.HELVETICA_REGULAR
      storyTextView.textAlignment = .center
      storyTextView.numberOfLines = 4
      
      verticalStack.addArrangedSubview(storyTitleView)
      verticalStack.addArrangedSubview(storyTextView)
      
      verticalStack.translatesAutoresizingMaskIntoConstraints = false
      
      self.addSubview(verticalStack)
      self.bringSubview(toFront: verticalStack)

      let horizontalMargin:CGFloat = 16.0
      let topStackConstriant = NSLayoutConstraint(item: verticalStack, attribute: .top, relatedBy: .equal , toItem: storyImageView, attribute: .top, multiplier: 1.0, constant: 0.0)
      let bottomStackConstriant = NSLayoutConstraint(item: verticalStack, attribute: .bottom, relatedBy: .equal , toItem: storyImageView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
      let leadingStackConstriant = NSLayoutConstraint(item: verticalStack, attribute: .leading , relatedBy: .equal , toItem: storyImageView, attribute: .trailing, multiplier: 1.0, constant: horizontalMargin)
      let trailingStackConstriant = NSLayoutConstraint(item: verticalStack, attribute: .trailing , relatedBy: .equal , toItem: self, attribute: .trailing, multiplier: 1.0, constant: -horizontalMargin)
      
      self.addConstraints([topStackConstriant, bottomStackConstriant, leadingStackConstriant, trailingStackConstriant])
      
      verticalStack.backgroundColor = UIColor.red
   }
}

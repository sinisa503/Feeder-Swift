//
//  Constant.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

struct Constant {
   
   static let FeedTableViewCellIdentifier = "FeedTableViewCell"
   static let NEWS_TITLE = "News"
   static let cellHeight:CGFloat = CGFloat(150)
   
   public static let DEFAULT_IMAGE_NAME = "mountain"
   public static let DEFAULT_TITLE = "Lorem ipsum"
   public static let DEFAULT_NEWS = "Lorem ipsum dolor sit amet, leo aliquam massa eleifend non fusce, quam ipsum tellus mauris ipsum, at augue mauris et eget sed morbi. Arcu wisi, nibh sed ligula aptent a, tincidunt diam sed gravida a, eu quis. Maecenas mauris morbi, per litora dolor aenean id odio at, nec nibh nec. Augue vitae sociis eleifend, class sed scelerisque sollicitudin erat, velit ut mauris phasellus velit, imperdiet diam eget ac ipsum, massa pellentesque iaculis nulla libero tortor. Suscipit id, ipsum etiam fusce, natoque massa tempus id, nam ipsum mattis elementum lorem non semper, quam wisi eu mattis. Nibh elit habitasse risus vel, pretium magna non quis sit, eros tortor dis nibh ad, aliquam a vestibulum nec in, urna aliquam quam molestie sociis tincidunt. Felis mauris quam semper mi nostra, orci urna nunc, erat maecenas sapien dictum. Urna ipsum mattis auctor, id amet dui semper sed. In pede tortor unde facilisis justo accumsan, lectus justo quis dolores donec, augue tristique varius diam non vel, tincidunt massa luctus gravida auctor, bibendum eleifend id sed. Et eu rutrum magna in commodo, nec nunc aliquet magna lectus lectus, vestibulum ac tortor in hac dignissimos morbi, lorem placerat id odio adipiscing mattis interdum. Luctus eros, nulla urna lorem volutpat sed fringilla."
}

struct CoreDataConstant {
   static let ENTITY_FEED = "Feed"
   static let ENTITY_STORY = "Story"
   static let FEED_SORT_DESCRIPTOR_PUBLISH_DATE = "publishDate"
   static let FEED_IMAGE_PROPERTY = "image"
}

struct Theme {
   public static let NAVIGATION_BAR_LIME = UIColor(hexString: "#CDDC39")
   public static let HELVETICA_BOLD = UIFont(name: "HelveticaNeue-Bold", size: 20)
   public static let HELVETICA_REGULAR = UIFont(name: "HelveticaNeue-Regular", size: 17)
}

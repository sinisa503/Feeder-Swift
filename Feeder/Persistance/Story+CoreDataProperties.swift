//
//  Story+CoreDataProperties.swift
//  
//
//  Created by Sinisa Vukovic on 08/04/2018.
//
//

import Foundation
import CoreData


extension Story {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Story> {
        return NSFetchRequest<Story>(entityName: "Story")
    }

    @NSManaged public var author: String?
    @NSManaged public var image: NSData?
    @NSManaged public var publishDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var uid: String?
    @NSManaged public var feed: Feed?

}

//
//  Feed+CoreDataProperties.swift
//  
//
//  Created by Sinisa Vukovic on 06/04/2018.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var image: NSData?
    @NSManaged public var descr: String?
    @NSManaged public var publishDate: NSDate?
    @NSManaged public var stories: NSSet?

}

// MARK: Generated accessors for stories
extension Feed {

    @objc(addStoriesObject:)
    @NSManaged public func addToStories(_ value: Story)

    @objc(removeStoriesObject:)
    @NSManaged public func removeFromStories(_ value: Story)

    @objc(addStories:)
    @NSManaged public func addToStories(_ values: NSSet)

    @objc(removeStories:)
    @NSManaged public func removeFromStories(_ values: NSSet)

}

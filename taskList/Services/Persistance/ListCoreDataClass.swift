//
//  List+CoreDataClass.swift
//  
//
//  Created by Давид Тоноян  on 11.12.2022.
//
//

import Foundation
import CoreData

@objc(List)
public final class List: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var listName: String?
    @NSManaged public var listItems: NSOrderedSet?
    @NSManaged public var listId: Int64
}

// MARK: Generated accessors for listItems
extension List {
    @objc(addListItemsObject:)
    @NSManaged public func addToListItems(_ value: Task)
    
    @objc(insertObject:inListItemsAtIndex:)
    @NSManaged public func insertIntoListItems(_ value: Task, at idx: Int)
    
    @objc(removeObjectFromListItemsAtIndex:)
    @NSManaged public func removeFromListItems(at idx: Int)
    
    @objc(removeListItemsObject:)
    @NSManaged public func removeFromListItems(_ value: Task)
}

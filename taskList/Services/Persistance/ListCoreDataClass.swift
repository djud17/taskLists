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
}

// MARK: Generated accessors for listItems
extension List {
    @objc(addListItemsObject:)
    @NSManaged public func addToListItems(_ value: Task)
}

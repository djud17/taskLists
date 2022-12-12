//
//  Task+CoreDataClass.swift
//  
//
//  Created by Давид Тоноян  on 11.12.2022.
//
//

import Foundation
import CoreData

@objc(Task)
public final class Task: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskName: String?
    @NSManaged public var taskStatus: String?
    @NSManaged public var taskId: Int64
}

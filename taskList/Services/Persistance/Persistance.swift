//
//  Persistance.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import CoreData

protocol ItemProtocol {
    var itemName: String { get set }
}

struct Task: ItemProtocol {
    var itemName: String
}

protocol PersistanceProtocol {
    func writeToPersistance(entityName: String)
    func readFromPersistance() -> [NSManagedObject]
    func deleteFromPersistance(entity: NSManagedObject)
}

final class CoreDataPersistance: PersistanceProtocol {
    func writeToPersistance(entityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "List",
                                                      in: managedContext) else { return }
        
        let taskList = NSManagedObject(entity: entity, insertInto: managedContext)
        taskList.setValue(entityName, forKeyPath: "listName")
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func readFromPersistance() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        return taskLists
    }
    
    func deleteFromPersistance(entity: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(entity)
        
        do {
            try managedContext.save()
        } catch {
            print("Could not delete entity. \(error), \(error.localizedDescription)")
        }
    }
}

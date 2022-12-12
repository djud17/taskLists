//
//  Persistance.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import CoreData

protocol PersistanceProtocol: AnyObject {
    var converter: ConverterProtocol { get }
    
    func writeToPersistance(entity: EntityProtocol)
    func readFromPersistance() -> [EntityProtocol]
    func deleteFromPersistance(entity: EntityProtocol)
    
    func insertItemToList(forList listEntityId: Int, toIndex index: Int, item: ItemProtocol)
    func removeItemFromList(fromList listEntityId: Int, atIndex index: Int)
    func appendItemToList(forList listEntityId: Int, item: ItemProtocol)
    func removeItemFromList(fromList listEntityId: Int, item: ItemProtocol)
}

private enum PersistanceKey {
    static let className = "List"
    static let propertyName = "listName"
}

final class CoreDataPersistance: PersistanceProtocol {
    var converter: ConverterProtocol = CoreDataConverter()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func writeToPersistance(entity: EntityProtocol) {
        guard let appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let list = List(context: managedContext)
        list.listName = entity.entityName
        list.listId = Int64(entity.entityId)
        
        entity.entityItems.forEach { item in
            let newTask = Task(context: managedContext)
            newTask.taskName = item.itemName
            newTask.taskStatus = item.itemStatus.rawValue
            newTask.taskId = Int64(item.itemId)
            list.addToListItems(newTask)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func readFromPersistance() -> [EntityProtocol] {
        guard let appDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PersistanceKey.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        return converter.convertFromPersistance(dataArray: taskLists)
    }
    
    func deleteFromPersistance(entity: EntityProtocol) {
        guard let appDelegate,
              let coreDataEntity = converter.convertToPersistance(data: entity) else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(coreDataEntity)
        
        do {
            try managedContext.save()
        } catch {
            print("Could not delete entity. \(error), \(error.localizedDescription)")
        }
    }
    
    func insertItemToList(forList listEntityId: Int, toIndex index: Int, item: ItemProtocol) {
        guard let appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PersistanceKey.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        guard let taskLists = taskLists as? [List] else { return }
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            let newTask = Task(context: managedContext)
            newTask.taskName = item.itemName
            newTask.taskStatus = item.itemStatus.rawValue
            newTask.taskId = Int64(item.itemId)
            list.insertIntoListItems(newTask, at: index)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func removeItemFromList(fromList listEntityId: Int, atIndex index: Int) {
        guard let appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PersistanceKey.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        guard let taskLists = taskLists as? [List] else { return }
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            list.removeFromListItems(at: index)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func appendItemToList(forList listEntityId: Int, item: ItemProtocol) {
        guard let appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PersistanceKey.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        guard let taskLists = taskLists as? [List] else { return }
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            let newTask = Task(context: managedContext)
            newTask.taskName = item.itemName
            newTask.taskStatus = item.itemStatus.rawValue
            newTask.taskId = Int64(item.itemId)
            list.addToListItems(newTask)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func removeItemFromList(fromList listEntityId: Int, item: ItemProtocol) {
        guard let appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PersistanceKey.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        guard let taskLists = taskLists as? [List] else { return }
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            guard let tasks = list.listItems else { return }
            
            for task in tasks {
                if let task = task as? Task {
                    if task.taskId == item.itemId {
                        list.removeFromListItems(task)
                        break
                    }
                }
            }
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
}

// MARK: - CoreData Converter

protocol ConverterProtocol {
    func convertToPersistance(data: EntityProtocol) -> NSManagedObject?
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [EntityProtocol]
}

final class CoreDataConverter: ConverterProtocol {
    func convertToPersistance(data: EntityProtocol) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObject()
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PersistanceKey.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        let convertedList = taskLists.first {
            $0.value(forKey: PersistanceKey.propertyName) as? String == data.entityName
        }
        
        return convertedList
    }
    
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [EntityProtocol] {
        guard let listArray = dataArray as? [List] else { return [] }
        
        var convertedData: [EntityProtocol] = []
        for list in listArray {
            guard let convertedEntity = createEntity(forList: list) else { return [] }
            convertedData.append(convertedEntity)
        }
        
        return convertedData
    }
    
    private func createEntity(forList list: List) -> EntityProtocol? {
        let listName = list.listName ?? ""
        let listItems = list.listItems ?? []
        let listId = Int(list.listId)
        let convertedEntity: EntityProtocol = ListEntity(entityName: listName, entityItems: [])
        convertedEntity.entityId = listId
        for item in listItems {
            guard let item = item as? Task else { return nil }
            
            let taskName = item.taskName ?? ""
            let taskStatus = item.taskStatus ?? ""
            let taskId = Int(item.taskId)
            var convertedTask: ItemProtocol = TaskItem(itemName: taskName, itemId: taskId)
            convertedTask.itemStatus = ItemStatus(rawValue: taskStatus) ?? .planned
            convertedEntity.entityItems.append(convertedTask)
        }
        return convertedEntity
    }
}

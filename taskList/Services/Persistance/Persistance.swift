//
//  Persistance.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import CoreData

typealias Persistance = EntityPersistance & ItemPersistance

protocol PersistanceProtocol: AnyObject, Persistance {
    var converter: ConverterProtocol { get }
}

protocol EntityPersistance {
    func writeToPersistance(entity: EntityProtocol)
    func readFromPersistance() -> [EntityProtocol]
    func deleteFromPersistance(entity: EntityProtocol)
}

protocol ItemPersistance {
    func insertItemToList(forList listEntityId: Int, toIndex index: Int, item: ItemProtocol)
    func removeItemFromList(fromList listEntityId: Int, atIndex index: Int)
    func appendItemToList(forList listEntityId: Int, item: ItemProtocol)
    func removeItemFromList(fromList listEntityId: Int, item: ItemProtocol)
}

private enum PersistanceKey {
    static let className = "List"
    static let propertyName = "listName"
}

// MARK: - CoreDataPersistance class

final class CoreDataPersistance: PersistanceProtocol {
    var converter: ConverterProtocol = CoreDataConverter()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var managedContext: NSManagedObjectContext? {
        appDelegate?.persistentContainer.viewContext
    }

    func writeToPersistance(entity: EntityProtocol) {
        guard let managedContext else { return }
        
        _ = createList(withEntity: entity)
        saveContext(managedContext: managedContext)
    }
    
    func readFromPersistance() -> [EntityProtocol] {
        guard let managedContext else { return [] }
        
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
        guard let managedContext,
              let coreDataEntity = converter.convertToPersistance(data: entity) else { return }
        
        managedContext.delete(coreDataEntity)
        saveContext(managedContext: managedContext)
    }
    
    func insertItemToList(forList listEntityId: Int, toIndex index: Int, item: ItemProtocol) {
        guard let managedContext else { return }
        
        let taskLists = getTasksFromPersistance()
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            let newTask = createTask(item: item)
            list.insertIntoListItems(newTask, at: index)
        }
        
        saveContext(managedContext: managedContext)
    }
    
    func removeItemFromList(fromList listEntityId: Int, atIndex index: Int) {
        guard let managedContext else { return }
        
        let taskLists = getTasksFromPersistance()
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            list.removeFromListItems(at: index)
        }
        
        saveContext(managedContext: managedContext)
    }
    
    func appendItemToList(forList listEntityId: Int, item: ItemProtocol) {
        guard let managedContext else { return }
        
        let taskLists = getTasksFromPersistance()
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            let newTask = createTask(item: item)
            list.addToListItems(newTask)
        }
        
        saveContext(managedContext: managedContext)
    }
    
    func removeItemFromList(fromList listEntityId: Int, item: ItemProtocol) {
        guard let managedContext else { return }
        
        let taskLists = getTasksFromPersistance()
        
        if let list = taskLists.first(where: { $0.listId == listEntityId }) {
            guard let tasks = list.listItems else { return }
            guard let task = getTaskById(tasks: tasks, itemId: item.itemId) else { return }
            
            list.removeFromListItems(task)
        }
        
        saveContext(managedContext: managedContext)
    }
    
    // MARK: - Private functions
    
    private func createList(withEntity entity: EntityProtocol) -> List {
        guard let managedContext else { return List() }
        
        let list = List(context: managedContext)
        list.listName = entity.entityName
        list.listId = Int64(entity.entityId)
        
        entity.entityItems.forEach { item in
            let newTask = createTask(item: item)
            list.addToListItems(newTask)
        }
        
        return list
    }
    
    private func createTask(item: ItemProtocol) -> Task {
        guard let managedContext else { return Task() }
        
        let newTask = Task(context: managedContext)
        newTask.taskName = item.itemName
        newTask.taskStatus = item.itemStatus.rawValue
        newTask.taskId = Int64(item.itemId)
        
        return newTask
    }
    
    private func saveContext(managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    private func getTasksFromPersistance() -> [List] {
        guard let managedContext else { return [] }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PersistanceKey.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        guard let taskLists = taskLists as? [List] else { return [] }
        
        return taskLists
    }
    
    private func getTaskById(tasks: NSOrderedSet, itemId: Int) -> Task? {
        var neededTask: Task?
        
        for task in tasks {
            guard let task = task as? Task else { return neededTask}
            
            if task.taskId == itemId {
                neededTask = task
                break
            }
        }
        
        return neededTask
    }
}

// MARK: - CoreData Converter

protocol ConverterProtocol {
    func convertToPersistance(data: EntityProtocol) -> NSManagedObject?
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [EntityProtocol]
}

private final class CoreDataConverter: ConverterProtocol {
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
            guard let convertedEntity = createConvertedEntity(forList: list) else { return [] }
            convertedData.append(convertedEntity)
        }
        
        return convertedData
    }
    
    private func createConvertedEntity(forList list: List) -> EntityProtocol? {
        let listName = list.listName ?? ""
        let listItems = list.listItems ?? []
        let listId = Int(list.listId)
        let convertedEntity: EntityProtocol = ListEntity(entityName: listName, entityItems: [])
        convertedEntity.entityId = listId
        
        for item in listItems {
            guard let task = item as? Task else { return nil }
            
            let convertedTask = createEntityItem(task: task)
            convertedEntity.entityItems.append(convertedTask)
        }
        
        return convertedEntity
    }
    
    private func createEntityItem(task: Task) -> ItemProtocol {
        let taskName = task.taskName ?? ""
        let taskStatus = task.taskStatus ?? ""
        let taskId = Int(task.taskId)
        var convertedTask: ItemProtocol = TaskItem(itemName: taskName, itemId: taskId)
        convertedTask.itemStatus = ItemStatus(rawValue: taskStatus) ?? .planned
        
        return convertedTask
    }
}

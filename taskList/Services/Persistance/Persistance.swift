//
//  Persistance.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import CoreData

protocol PersistanceProtocol {
    var converter: ConverterProtocol { get }
    
    func writeToPersistance(entity: any EntityProtocol)
    func readFromPersistance() -> [any EntityProtocol]
    func deleteFromPersistance(entity: any EntityProtocol)
}

private enum PersistanceKey {
    static let className = "List"
    static let propertyName = "listName"
}

final class CoreDataPersistance: PersistanceProtocol {
    var converter: ConverterProtocol = CoreDataConverter()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func writeToPersistance(entity: any EntityProtocol) {
        guard let appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let list = List(context: managedContext)
        list.listName = entity.entityName
        
        entity.entityItems.forEach { item in
            let new = Task(context: managedContext)
            new.taskName = item.itemName
            new.taskStatus = item.itemStatus.rawValue
            list.addToListItems(new)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func readFromPersistance() -> [any EntityProtocol] {
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
    
    func deleteFromPersistance(entity: any EntityProtocol) {
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
}

// MARK: - CoreData Converter

protocol ConverterProtocol {
    func convertToPersistance(data: any EntityProtocol) -> NSManagedObject?
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [any EntityProtocol]
}

final class CoreDataConverter: ConverterProtocol {
    func convertToPersistance(data: any EntityProtocol) -> NSManagedObject? {
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
    
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [any EntityProtocol] {
        guard let listArray = dataArray as? [List] else { return [] }
        
        var convertedData: [any EntityProtocol] = []
        for list in listArray {
            guard let items = list.listItems,
                  let convertedEntity = createEntity(withName: list.listName, and: items) else { return [] }
            convertedData.append(convertedEntity)
        }
        
        return convertedData
    }
    
    private func createEntity(withName listName: String?, and items: NSOrderedSet) -> EntityProtocol? {
        let listName = listName ?? ""
        var convertedEntity: any EntityProtocol = ListEntity(entityName: listName, entityItems: [])
        for item in items {
            guard let item = item as? Task else { return nil }
            
            let taskName = item.taskName ?? ""
            let taskStatus = item.taskStatus ?? ""
            var convertedTask: any ItemProtocol = TaskItem(itemName: taskName)
            convertedTask.itemStatus = ItemStatus(rawValue: taskStatus) ?? .planned
            convertedEntity.entityItems.append(convertedTask)
        }
        return convertedEntity
    }
}

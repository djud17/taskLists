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
    
    func writeToPersistance(entityName: String)
    func readFromPersistance() -> [any EntityProtocol]
    func deleteFromPersistance(entity: any EntityProtocol)
}

private enum KeyValue {
    static let className = "List"
    static let propertyName = "listName"
}

final class CoreDataPersistance: PersistanceProtocol {
    var converter: ConverterProtocol = CoreDataConverter()

    func writeToPersistance(entityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: KeyValue.className,
                                                      in: managedContext) else { return }
        
        let taskList = NSManagedObject(entity: entity, insertInto: managedContext)
        taskList.setValue(entityName, forKeyPath: KeyValue.propertyName)
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error), \(error.localizedDescription)")
        }
    }
    
    func readFromPersistance() -> [any EntityProtocol] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: KeyValue.className)
        
        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        return converter.convertFromPersistance(dataArray: taskLists)
    }
    
    func deleteFromPersistance(entity: any EntityProtocol) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: KeyValue.className)

        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        
        let convertedList = taskLists.first {
            $0.value(forKey: KeyValue.propertyName) as? String == data.listName
        }
        
        return convertedList
    }
    
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [any EntityProtocol] {
        var convertedData: [any EntityProtocol] = []
        
        for data in dataArray {
            let entityName = (data.value(forKey: KeyValue.propertyName) as? String) ?? ""
            let convertedEntity: any EntityProtocol = ListEntity(listName: entityName, listItems: [])
            convertedData.append(convertedEntity)
        }
        
        return convertedData
    }
}

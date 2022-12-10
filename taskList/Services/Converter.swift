//
//  Converter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import CoreData

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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")

        var taskLists: [NSManagedObject] = []
        do {
            taskLists = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        for list in taskLists where list.value(forKey: "listName") as? String == data.listName {
            return list
        }
        
        return nil
    }
    
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [any EntityProtocol] {
        var convertedData: [any EntityProtocol] = []
        
        for data in dataArray {
            let entityName = (data.value(forKey: "listName") as? String) ?? ""
            let convertedEntity: any EntityProtocol = ListEntity(listName: entityName, listItems: [])
            convertedData.append(convertedEntity)
        }
        
        return convertedData
    }
}

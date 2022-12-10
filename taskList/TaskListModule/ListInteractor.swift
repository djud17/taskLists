//
//  ListInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ListInteractorProtocol {
    var persistance: PersistanceProtocol { get set }
    var converter: ConverterProtocol { get set }
    
    func getData() -> [any EntityProtocol]
    func checkData(entityName: String) -> Bool
    func saveData(entityName: String)
    func deleteData(entity: any EntityProtocol)
}

final class ListInteractor: ListInteractorProtocol {
    var persistance: PersistanceProtocol
    var converter: ConverterProtocol
    
    init(persistance: PersistanceProtocol, converter: ConverterProtocol) {
        self.persistance = persistance
        self.converter = converter
    }
    
    func getData() -> [any EntityProtocol] {
        let arrayFromCoreData = persistance.readFromPersistance()
        let data: [any EntityProtocol] = converter.convertFromPersistance(dataArray: arrayFromCoreData)
        
        return data
    }
    
    func checkData(entityName: String) -> Bool {
        return entityName.isEmpty
    }

    func saveData(entityName: String) {
        persistance.writeToPersistance(entityName: entityName)
    }
    
    func deleteData(entity: any EntityProtocol) {
        guard let convertedEntity = converter.convertToPersistance(data: entity) else { return }
        persistance.deleteFromPersistance(entity: convertedEntity)
    }
}

//
//  ListEntity.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation
import CoreData

protocol EntityProtocol: AnyObject {
    var entityName: String { get set }
    var entityItems: [ItemProtocol] { get set }
    var entityId: Int { get set }
}

final class ListEntity: EntityProtocol {
    var entityId: Int
    var entityName: String
    var entityItems: [ItemProtocol]
    
    init(entityName: String, entityItems: [ItemProtocol], entityId: Int = 0) {
        self.entityName = entityName
        self.entityItems = entityItems
        self.entityId = entityId
    }
}

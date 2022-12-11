//
//  ListEntity.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation
import CoreData

protocol EntityProtocol {
    var entityName: String { get set }
    var entityItems: [ItemProtocol] { get set }
}

struct ListEntity: EntityProtocol {
    var entityName: String = ""
    var entityItems: [ItemProtocol] = []
}

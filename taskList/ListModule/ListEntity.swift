//
//  ListEntity.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol EntityProtocol {
    associatedtype EntityItem
    var listName: String { get set }
    var listItems: [EntityItem] { get set }
}

struct ListEntity: EntityProtocol {
    var listName: String
    var listItems: [Task]
}

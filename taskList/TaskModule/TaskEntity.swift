//
//  TaskEntity.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

enum ItemStatus: String {
    case planned
    case completed
}

protocol ItemProtocol {
    var itemName: String { get set }
    var itemStatus: ItemStatus { get set }
}

struct TaskItem: ItemProtocol {
    var itemName: String
    var itemStatus: ItemStatus = .planned
}

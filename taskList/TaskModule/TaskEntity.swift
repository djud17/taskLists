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

protocol ItemProtocol: AnyObject {
    var itemName: String { get set }
    var itemStatus: ItemStatus { get set }
    var itemId: Int { get set }
}

final class TaskItem: ItemProtocol {
    var itemName: String
    var itemStatus: ItemStatus
    var itemId: Int
    
    init(itemName: String, itemStatus: ItemStatus = .planned, itemId: Int = 0) {
        self.itemName = itemName
        self.itemStatus = itemStatus
        self.itemId = itemId
    }
}

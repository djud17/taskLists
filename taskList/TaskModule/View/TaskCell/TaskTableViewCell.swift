//
//  TaskTableViewCell.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
}

struct TaskTableViewCellModel {
    let taskStatus: TaskStatus
    let taskName: String
    
    enum TaskStatus {
        case planned
        case completed
    }
}

extension TaskTableViewCellModel: CellViewModel {
    func setup(cell: TaskTableViewCell) {
        cell.taskNameLabel.text = taskName
        cell.taskNameLabel.textColor = Constants.Colors.blue
        cell.taskStatusLabel.text = {
            switch self.taskStatus {
            case .completed:
                return "\u{25C9}"
            case .planned:
                return "\u{25CB}"
            }
        }()
        cell.taskStatusLabel.textColor = Constants.Colors.blue
    }
}
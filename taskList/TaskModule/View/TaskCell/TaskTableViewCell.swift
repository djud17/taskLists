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
    let taskStatus: ItemStatus
    let taskName: String
}

extension TaskTableViewCellModel: CellViewModel {
    func setup(cell: TaskTableViewCell) {
        let (color, taskStatus) = chooseStyle(itemStatus: self.taskStatus)
        cell.taskNameLabel.text = taskName
        cell.taskStatusLabel.text = taskStatus
        cell.taskNameLabel.textColor = color
        cell.taskStatusLabel.textColor = Constants.Color.blue
    }
    
    private func chooseStyle(itemStatus: ItemStatus) -> (UIColor, String) {
        let (color, status): (UIColor, String) = {
            switch itemStatus {
            case .completed:
                return (Constants.Color.lightBlue, Constants.Symbol.filledPoint)
            case .planned:
                return (Constants.Color.blue, Constants.Symbol.emptyPoint)
            }
        }()
        
        return (color, status)
    }
}

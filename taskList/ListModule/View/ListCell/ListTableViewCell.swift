//
//  ListTableViewCell.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var listNameLabel: UILabel!
}

struct ListTableViewCellModel {
    let listName: String
}

extension ListTableViewCellModel: CellViewModel {
    func setup(cell: ListTableViewCell) {
        cell.listNameLabel.text = listName
        cell.listNameLabel.textColor = Constants.Colors.blue
    }
}

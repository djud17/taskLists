//
//  ListTableViewCell.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var listNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct ListTableViewCellModel {
    let listName: String
}

extension ListTableViewCellModel: CellViewModel {
    func setup(cell: ListTableViewCell) {
        cell.listNameLabel.text = listName
    }
}

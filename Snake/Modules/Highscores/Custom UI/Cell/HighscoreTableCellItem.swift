//
//  HighscoreTableCellItem.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation

struct HighscoreTableCellItem {
    let userData: UserModel
}

// MARK: - AssociableTableCellItem conformance

extension HighscoreTableCellItem: AssociableTableCellItem {
    typealias AssociatedCell = HighscoreTableViewCell
}

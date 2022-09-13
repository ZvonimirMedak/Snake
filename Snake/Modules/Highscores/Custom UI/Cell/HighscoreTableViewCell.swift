//
//  HighscoreTableViewCell.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation
import UIKit

final class HighscoreTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
}

// MARK: - Extensions -

// MARK: - Configuration

extension HighscoreTableViewCell: ItemConfigurable {

    func configure(with item: HighscoreTableCellItem) {
        nicknameLabel.text = item.userData.nickname
        scoreLabel.text = "\(item.userData.score)"
        emailLabel.isHiddenInStackView = true
        nameLabel.isHiddenInStackView = true

        if item.userData.email.isNotBlank {
            emailLabel.isHiddenInStackView = false
            emailLabel.text = item.userData.email
        }

        if item.userData.name.isNotBlank {
            nameLabel.isHiddenInStackView = false
            nameLabel.text = item.userData.name
        }
    }
}

//
//  ButtonConfigurator.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation
import UIKit

struct ButtonConfigurator {
    let text: String
    let theme: SnakeButton.Theme
    var size: SnakeButton.Size
    let didSelect: () -> Void
}

// MARK: - Extensions -

// MARK: - ComponentConfigurable conformance

extension ButtonConfigurator: ComponentConfigurable {

    var view: UIView {
        let button = SnakeButton()
        button.configure(for: theme, size: size)
        button.configure(with: didSelect)
        button.setTitle(text, for: .normal)
        return button
    }
}

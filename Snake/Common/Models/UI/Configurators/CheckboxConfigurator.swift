//
//  CheckboxConfigurator.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit

struct CheckboxConfigurator {
    let text: String
    let didSelect: (Bool) -> Void
}

// MARK: - Extensions -

// MARK: ComponentConfigurable conformance

extension CheckboxConfigurator: ComponentConfigurable {

    var view: UIView {
        let checkboxView = CheckboxView()

        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)

        checkboxView.configure(with: label)
        checkboxView.configure(with: didSelect)
        return checkboxView
    }
}

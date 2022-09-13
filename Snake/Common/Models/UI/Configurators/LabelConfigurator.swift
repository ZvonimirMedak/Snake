//
//  LabelConfigurator.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import Foundation
import UIKit

// MARK: - Constants extension -

private extension Constants {

    enum LabelConfigurator {
        static let leadingTrailingInset: CGFloat = 48
    }
}

struct LabelConfigurator {
    let text: String
    var fontSize: CGFloat = 18
}

// MARK: - Extensions

// MARK: - ComponentConfigurable conformance

extension LabelConfigurator: ComponentConfigurable {

    var view: UIView {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = .systemFont(ofSize: fontSize)
        label.textColor = .black
        label.sizeToFit()
        let width = UIScreen.main.bounds.width - Constants.LabelConfigurator.leadingTrailingInset
        let height = label.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingExpandedSize.height))
        label.frame.size = height
        return label
    }
}

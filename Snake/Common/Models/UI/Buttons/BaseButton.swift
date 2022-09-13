//
//  BaseButton.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit

class BaseButton: UIButton {

    func animate(isSelected: Bool) {
        let transform: CGAffineTransform = isSelected ? .init(scaleX: 0.95, y: 0.95) : .identity
        animate(transform)
    }

    func animate(_ transform: CGAffineTransform) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: [.curveEaseInOut, .allowUserInteraction, .transitionCrossDissolve],
            animations: { self.transform = transform }
        )
    }
}

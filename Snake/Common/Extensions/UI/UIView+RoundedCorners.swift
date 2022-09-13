//
//  UIView+RoundedCorners.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import UIKit

extension UIView {

    /// Adds rounded corner edges to the view on specified coners with
    /// same radius for all of them.
    ///
    /// Be aware that this method uses layer for setting the mask
    /// so, probably you'll want to set layer.masksToBounds = true
    /// and use this from (did)layoutSubivews method since layer
    /// frame can change during the layout cycle.
    ///
    /// - Parameters:
    ///   - corners: Corners where to place round edge
    ///   - radius: Corner radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        var maskedCorners: CACornerMask = []

        if corners.contains(.topLeft) { maskedCorners.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { maskedCorners.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { maskedCorners.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { maskedCorners.insert(.layerMaxXMaxYCorner) }

        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
}

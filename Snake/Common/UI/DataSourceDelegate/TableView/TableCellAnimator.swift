//
//  TableCellAnimator.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit

final class TableCellAnimator {

    typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

    // MARK: - Private properties -

    private var hasAnimatedAllCells = false
    private var animatedCellIndexPaths: [IndexPath] = []

    private let animation: Animation

    // MARK: - Init -

    init(animation: @escaping Animation) {
        self.animation = animation
    }
}

// MARK: - Extensions -

// MARK: - Animating & resetting

extension TableCellAnimator {

    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !animatedCellIndexPaths.contains(indexPath) else { return }
        animation(cell, indexPath, tableView)
        animatedCellIndexPaths.append(indexPath)
    }

    func reset() {
        animatedCellIndexPaths = []
    }
}

extension TableCellAnimator {

    enum SlideInPosition {
        case left
        case right
    }
}

// MARK: - Animation factory -

enum TableCellAnimationFactory {

    static func makeSlideInAnimation(
        duration: TimeInterval,
        delay: Double,
        from position: TableCellAnimator.SlideInPosition
    ) -> TableCellAnimator.Animation {
        return { cell, _, _ in
            let translationX = position == .left ? -(cell.frame.width / 4) : cell.frame.width / 4
            cell.transform = .init(translationX: translationX, y: 0)

            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: [.curveEaseInOut, .allowUserInteraction],
                animations: {
                    cell.transform = .identity
                }
            )
        }
    }

    static func makeSlideInWithFadeAnimation(
        duration: TimeInterval,
        delay: Double,
        from position: TableCellAnimator.SlideInPosition
    ) -> TableCellAnimator.Animation {
        return { cell, _, _ in
            let translationX = position == .left ? -(cell.frame.width / 4) : cell.frame.width / 4
            cell.transform = .init(translationX: translationX, y: 0)
            cell.alpha = 0

            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: [.curveEaseInOut, .allowUserInteraction],
                animations: {
                    cell.transform = .identity
                    cell.alpha = 1
                }
            )
        }
    }
}


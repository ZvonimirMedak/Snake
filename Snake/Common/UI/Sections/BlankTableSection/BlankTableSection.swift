//
//  BlankTableSection.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit

/// Represents blank section - without header or footer
/// Used in conjuction with table view data source delegate
/// for easy mapping items to single section without footer
/// or header - just like you didn't use section at all.
class BlankTableSection: TableSectionItem {

    // MARK: - Public properties -

    var items: [TableCellItem]

    // MARK: - Private properties -

    private let configuration: Configuration

    init(items: [TableCellItem], configuration: Configuration = .init()) {
        self.items = items
        self.configuration = configuration
    }

    convenience init?(items: [TableCellItem]?) {
        guard let items = items else {
            return nil
        }
        self.init(items: items)
    }

    var headerHeight: CGFloat { configuration.headerHeight }

    var footerHeight: CGFloat { configuration.footerHeight }

    var estimatedHeaderHeight: CGFloat { headerHeight }

    var estimatedFooterHeight: CGFloat { footerHeight }
}

extension BlankTableSection {

    func headerView(from tableView: UITableView, at index: Int) -> UIView? {
        let view = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: headerHeight))
        view.backgroundColor = configuration.headerBackgroundColor
        return view
    }

    func footerView(from tableView: UITableView, at index: Int) -> UIView? {
        let view = UIView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: footerHeight))
        view.backgroundColor = configuration.footerBackgroundColor
        return view
    }
}


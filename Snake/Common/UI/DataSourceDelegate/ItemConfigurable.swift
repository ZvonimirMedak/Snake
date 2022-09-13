//
//  ItemConfigurable.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation

/// Protocol intended for use with `UITableViewCell` or `UITableViewCell`
/// along with `TableCellItem` or `CollectionCellItem`
///
/// Can be used to add shared behaviour for anything which can be configured with an Item
public protocol ItemConfigurable {
    associatedtype ConfigurationItem

    /// Configures the implementee with the recieved item
    /// - Parameter item: item containing configuration data
    func configure(with item: ConfigurationItem)
}

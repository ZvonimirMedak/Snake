//
//  ComponentConfigurable.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import UIKit

/// A common protocol for components that can be loaded through their configurators.

/// The configurator which implements the protocol needs to supply a concrete view for which it's used.
protocol ComponentConfigurable {
    var view: UIView { get }
}

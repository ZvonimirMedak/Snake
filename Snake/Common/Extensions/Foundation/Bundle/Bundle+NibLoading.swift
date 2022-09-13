//
//  Bundle+NibLoading.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit

extension Bundle {

    @discardableResult
    func load<T: UIView>(viewOfType _: T.Type, owner: Any? = nil) -> T {
        let viewName = String(describing: T.self)
        return loadNibNamed(viewName, owner: nil, options: nil)!.first as! T
    }
}

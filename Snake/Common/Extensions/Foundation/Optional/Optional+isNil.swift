//
//  Optional+isNil.swift
//  Snake
//
//  Created by Zvonimir Medak on 25.06.2022..
//

import Foundation

extension Optional {

    var isNil: Bool {
        self == nil
    }

    var isNotNil: Bool {
        !isNil
    }
}

//
//  ContactCategory.swift
//  Snake
//
//  Created by Zvonimir Medak on 25.06.2022..
//

import Foundation

struct ContactCategory: OptionSet {
    public init(rawValue: Int){
        self.rawValue = rawValue
    }

    let rawValue: Int
    static let snakeHead = ContactCategory(rawValue: 3 << 2)
    static let snake = ContactCategory(rawValue: 1 << 1)
    static let arena = ContactCategory(rawValue: 1 << 0)
    static let food = ContactCategory(rawValue: 2 << 1)
    static let nothing = ContactCategory(rawValue: 5 << 5)
}

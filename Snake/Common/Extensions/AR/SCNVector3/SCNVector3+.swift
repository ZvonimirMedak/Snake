//
//  SCNVector3+.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.02.2022..
//

import Foundation
import SceneKit

extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
}


//
//  SCNAction+ForeverActions.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import Foundation
import SceneKit

extension SCNAction {

    static func rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        return SCNAction.repeatForever(rotation)
    }

    static func move(to position: SCNVector3, time: TimeInterval) -> SCNAction {
        return SCNAction.repeatForever(SCNAction.move(to: position, duration: time))
    }
}

//
//  SCNNode+RemoveAllNodes.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//

import Foundation
import SceneKit

extension SCNNode {

    func removeAllChildNodes() {
        enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
    }
}

//
//  ARSCNView+RemoveAllChildNodes.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.02.2022..
//

import Foundation
import ARKit

extension ARSCNView {

    func removeAllChildNodes() {
        scene.rootNode.removeAllChildNodes()
    }
}

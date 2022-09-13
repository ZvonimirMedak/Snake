//
//  SCNNode + AddChildNodes.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//

import Foundation
import ARKit

extension SCNNode {

    func addChildNodes(_ nodes: SCNNode...) {
        nodes.forEach(addChildNode)
    }

    func addChildNodes(_ nodes: [SCNNode]) {
        nodes.forEach(addChildNode)
    }
}

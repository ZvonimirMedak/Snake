//
//  SCNNode+RemoveAllActions.swift
//  Snake
//
//  Created by Zvonimir Medak on 27.06.2022..
//

import Foundation
import SceneKit

extension SCNNode {

    func removeAllActions() {
        actionKeys.forEach(removeAction(forKey:))
    }
}

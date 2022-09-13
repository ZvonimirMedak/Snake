//
//  SCNPhysicsContactDelegateProxy.swift
//  Snake
//
//  Created by Zvonimir Medak on 09.05.2022..
//

import Combine
import CombineCocoa
import ARKit

extension ARSCNView {

    // MARK: - Public properties -

    var didBeginContact: AnyPublisher<SCNPhysicsContact, Never> {
        let selector = #selector(SCNPhysicsContactDelegate.physicsWorld(_:didBegin:))
        return delegateProxy.interceptSelectorPublisher(selector)
            .map { $0[1] as! SCNPhysicsContact }
            .eraseToAnyPublisher()
    }

    // MARK: - Private properties -

    private var delegateProxy: ARSCNViewDelegateProxy {
        .createDelegateProxy(for: self)
    }
}

// MARK: - Delegate proxy -

private class ARSCNViewDelegateProxy: DelegateProxy, SCNPhysicsContactDelegate, DelegateProxyType {
    func setDelegate(to object: ARSCNView) {
        object.scene.physicsWorld.contactDelegate = self
    }
}

//
//  ARSCNViewDelegateProxy.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//

import Combine
import CombineCocoa
import ARKit

extension ARSCNView {

    // MARK: - Public properties -

    var willRenderScene: AnyPublisher<SCNScene, Never> {
        let selector = #selector(ARSCNViewDelegate.renderer(_:willRenderScene:atTime:))
        return delegateProxy.interceptSelectorPublisher(selector)
            .map { $0[1] as! SCNScene }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private properties -

    private var delegateProxy: ARSCNViewDelegateProxy {
        .createDelegateProxy(for: self)
    }
}

// MARK: - Delegate proxy -

private class ARSCNViewDelegateProxy: DelegateProxy, ARSCNViewDelegate, DelegateProxyType {
    func setDelegate(to object: ARSCNView) {
        object.delegate = self
    }
}

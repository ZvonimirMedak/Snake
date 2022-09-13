//
//  Combine+Binding.swift
//  Snake
//
//  Created by Zvonimir Medak on 23.05.2022..
//

import Combine
import CombineExt

extension Publisher where Failure == Never {

    func bind(to relay: PassthroughRelay<Output>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }

    func bind(to relay: PassthroughRelay<Output?>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }

    func bind(to relay: CurrentValueRelay<Output>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }

    func bind(to relay: CurrentValueRelay<Output?>) -> Cancellable {
        sink(receiveValue: { [weak relay] in relay?.accept($0) })
    }
}

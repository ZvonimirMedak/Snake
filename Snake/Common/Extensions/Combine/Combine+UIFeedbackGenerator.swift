//
//  Combine+UIFeedbackGenerator.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation
import UIKit
import Combine

extension Publisher {

    func selectionHapticFeedback() -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in UISelectionFeedbackGenerator().prepareAndGenerateFeedback() })
    }
}

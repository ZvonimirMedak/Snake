//
//  FeedbackGenerator+Utility.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit

extension UISelectionFeedbackGenerator {

    func prepareAndGenerateFeedback() {
        prepare()
        selectionChanged()
    }
}

extension UINotificationFeedbackGenerator {

    func prepareAndGenerateFeedback(for type: UINotificationFeedbackGenerator.FeedbackType) {
        prepare()
        notificationOccurred(type)
    }
}

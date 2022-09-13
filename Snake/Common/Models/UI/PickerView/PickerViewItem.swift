//
//  PickerViewItem.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation
import CombineExt

struct PickerViewItem {
    let selectedButtonRelay: CurrentValueRelay<PickerView.SelectedButton>
    let title: String
    let configuration: PickerView.Configuration
}

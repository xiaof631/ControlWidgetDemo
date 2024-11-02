//
//  ControlExtBundle.swift
//  ControlExt
//
//  Created by user on 2/11/2024.
//

import WidgetKit
import SwiftUI

@main
struct ControlExtBundle: WidgetBundle {
    var body: some Widget {
        // 工程自动创建的
        ControlExt()
        ControlExtControl()
        ControlExtLiveActivity()
        
        // Demo
        ControlToggleWidget()
        ControlButtonWidget()
    }
}

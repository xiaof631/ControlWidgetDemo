//
//  ControlToggleWidgetIntent.swift
//  ControlWidgetDemo
//
//  Created by user on 2/11/2024.
//

import SwiftUI
import AppIntents
import ActivityKit


@available(iOS 18.0, *)
struct ControlToggleWidgetIntent:SetValueIntent,LiveActivityStartingIntent {

    static var title: LocalizedStringResource = "ControlToggleWidgetIntent"
    
    @Parameter(
        title: .init("widgets.controls.parameter.value", defaultValue: "value")
    )
    var value: Bool
    
    
    
    @MainActor
    func startLiveActivity(){
        
        do {
            let _ = try Activity<ControlExtAttributes>.request(attributes: ControlExtAttributes(name: "Demo"), contentState:ControlExtAttributes.ContentState(emoji: "🤩") ,pushType:.none)
        } catch let error {
            /// 直接调用会直接抛出出异常 ActivityKit.ActivityAuthorizationError.unsupportedTarget
            /// 需要在Info.Plist里配置 Supports Live Activities  True
            debugPrint("开启灵动岛失败:\(error)")
        }
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        // 此处实际业务处理
        // 开启灵动岛、播放声音、开启振动等
        
        // 如果有使用到开启LiveActivity 这个数据管理类的数据需要做持久化处理，否则value会一直变化,出现不可预知的异常
        ControlToggleWidgerValueManage.shared.value.toggle()
    
        // 开启灵动岛
        self.startLiveActivity()
        
        return .result()
    }
    
}


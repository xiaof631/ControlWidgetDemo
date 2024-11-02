//
//  ControlWidget.swift
//  ControlWidgetDemo
//
//  Created by user on 2/11/2024.
//

import SwiftUI
import WidgetKit
import AppIntents


@available(iOS 18.0, *)
struct ControlToggleWidget: ControlWidget {
    static let kind = "com.ios.controlDemo.toggle"
    var body: some ControlWidgetConfiguration{
        AppIntentControlConfiguration(kind: ControlToggleWidget.kind, provider: ControlWidgetToggleProvider()) { item in
            
            // 开启状态的图标颜色
            let themeColor = Color.orange
        
            ControlWidgetToggle(isOn:ControlToggleWidgerValueManage.shared.value, action:ControlToggleWidgetIntent()) {
                // 实际是一个Lable 可自适应实际小、中、大三种尺寸
                // 使用的文字和图标可以通过 item.entity 去关联一个数据模型，从数据模型取
                Label {
//                    Text("标题")
                    Text(item.entity.title ?? "标题")
                    Text("副标题")
                } icon: {
                    ///  此处图标使用实际业务对应的SF图标
                    // 系统SF图标
//                    Image(systemName: "figure.walk")
                    // 自定义SF图标
                    Image("icon_control_katong_1")
                }

            }.tint(themeColor) // 设定开启状态的图标颜色
        }.displayName("控制组件")
            .description("选择自定义组件")
            .promptsForUserConfiguration()
    }
}

extension ControlToggleWidget{
    
    struct ControlToggleItem{
        let entity:ControlWidgetToggleEntity
    }
    
    struct ControlWidgetToggleProvider:AppIntentControlValueProvider{
        
        
        func currentValue(configuration: ControlToggleWidgetConfiguration) async throws -> ControlToggleItem {
            return item(configuration: configuration)
        }
        
        
        func previewValue(configuration: ControlToggleWidget.ControlToggleWidgetConfiguration) -> ControlToggleWidget.ControlToggleItem {
            return item(configuration: configuration)
        }
        
    
        private func item(configuration: ControlToggleWidgetConfiguration) -> ControlToggleItem{
            .init(entity: configuration.entity ?? ControlWidgetToggleEntity(id: UUID().uuidString, uuid: "11111"))
        }
    
    }
    
    struct ControlToggleWidgetConfiguration: ControlConfigurationIntent {
        init() {
            
        }
        static var title: LocalizedStringResource = .init(
            "widgets.controls.ControlWidgetDemoConfiguration.toggle.title",
            defaultValue: "控制选项"
        )
        
        
        static var openAppWhenRun: Bool = true
        
        
        @Parameter(
            title: .init("widgets.controls.ControlWidgetDemoConfiguration.toggle.data", defaultValue: "控制选项")
        )
        var entity: ControlWidgetToggleEntity?
        
        
        @MainActor
        func perform() async throws -> some  IntentResult{
            return .result(value: entity)
        }
    }
}



// 自定义控制中心选择列表
@available(iOS 18.0, *)
struct ControlWidgetToggleEntity: AppEntity {
    
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "选择控制组件")

    static let defaultQuery = ControlWidgetToggleEntityQuery()

    var id:String
    var uuid:String
    var title:String?
 

    var displayRepresentation: DisplayRepresentation {
        let title =  self.title ?? "控制组件"
        let subTitle = "还未选择控制组件"
        let iconName =  "web_camera"
        return DisplayRepresentation(title: "\(title)",subtitle: "\(subTitle)",image: .init(named: iconName,isTemplate: false))
    }
    
    init(id: String, uuid: String,title:String? = nil) {
        self.id = id
        self.uuid = uuid
        self.title = title
      
    }

}

@available(iOS 18.0, *)
struct ControlWidgetToggleEntityQuery: EntityQuery,EntityStringQuery {
  
    /// 实际测试结果是需要同步实现配置数据的加载，否则选择配置后，数据无法回调到控制组件
    let dataItems = [Int](1...20).map { idx in
        return ControlWidgetToggleEntity(id: UUID().uuidString, uuid: "customId_\(idx)",title: "样式\(idx)")
    }
    
    func entities(for identifiers: [String]) async throws -> [ControlWidgetToggleEntity] {
        return dataItems.filter({ entity in
            return identifiers.contains(entity.id)
        })
    }
    
    func entities(matching string: String) async throws -> IntentItemCollection<ControlWidgetToggleEntity> {
       
   
        let reslutItems =  dataItems.filter({ item in
            return (item.title ?? "").contains(string)
        })
        return .init(items: reslutItems)
    }
    
    func suggestedEntities() async throws -> IntentItemCollection<ControlWidgetToggleEntity> {
        return .init(items: dataItems)
    }
    
    
    /// 官方及现有网上教程是用一个函数来异步获取保存的配置信息，但实际是选择后,数据不会同步
    private func getItems()  async throws -> [ControlWidgetToggleEntity]{
        return dataItems
    }
}

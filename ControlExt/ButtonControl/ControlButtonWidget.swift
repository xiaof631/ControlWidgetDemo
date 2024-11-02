

import SwiftUI
import AppIntents
import WidgetKit
import ActivityKit



@available(iOS 18.0, *)
struct ControlButtonWidget: ControlWidget {
    static let kind = "com.ios.controlDemo.button"
    var body: some ControlWidgetConfiguration{
        AppIntentControlConfiguration(kind: ControlButtonWidget.kind, provider: ControlWidgetButtonProvider()) { item in
            ControlWidgetButton(action: ControlButtonWidgetIntent(uuid: item.entity.uuid)) {
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
                    Image("icon_control_katong_7")
                }
            }
        }.displayName("启动组件")
            .description("选择自定义组件")
            .promptsForUserConfiguration()
    }
}


extension ControlButtonWidget{
    
    struct ControlToggleItem{
        let entity:ControlWidgetButtonEntity
    }
    
    struct ControlWidgetButtonProvider:AppIntentControlValueProvider{
        
        
        func currentValue(configuration: ControlButtonWidgetConfiguration) async throws -> ControlToggleItem {
            return item(configuration: configuration)
        }
        
        
        func previewValue(configuration: ControlButtonWidget.ControlButtonWidgetConfiguration) -> ControlButtonWidget.ControlToggleItem {
            return item(configuration: configuration)
        }
        
    
        private func item(configuration: ControlButtonWidgetConfiguration) -> ControlToggleItem{
            .init(entity: configuration.entity ?? ControlWidgetButtonEntity(id: UUID().uuidString, uuid: "11111"))
        }
    
    }
    
    struct ControlButtonWidgetConfiguration: ControlConfigurationIntent {
        init() {
            
        }
        static var title: LocalizedStringResource = .init(
            "widgets.controls.ControlWidgetDemoConfiguration.button.title",
            defaultValue: "启动选项"
        )
        
        
        static var openAppWhenRun: Bool = true
        
        
        @Parameter(
            title: .init("widgets.controls.ControlWidgetDemoConfiguration.button.data", defaultValue: "启动选项")
        )
        var entity: ControlWidgetButtonEntity?
        
        
        @MainActor
        func perform() async throws -> some  IntentResult{
            return .result(value: entity)
        }
    }
}



// 自定义启动中心选择列表
@available(iOS 18.0, *)
struct ControlWidgetButtonEntity: AppEntity {
    
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "选择启动组件")

    static let defaultQuery = ControlWidgetButtonEntityQuery()

    var id:String
    var uuid:String
    var title:String?
 

    var displayRepresentation: DisplayRepresentation {
        let title =  self.title ?? "启动组件"
        let subTitle = "还未选择启动组件"
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
struct ControlWidgetButtonEntityQuery: EntityQuery,EntityStringQuery {
  
    /// 实际测试结果是需要同步实现配置数据的加载，否则选择配置后，数据无法回调到启动组件
    let dataItems = [Int](1...20).map { idx in
        return ControlWidgetButtonEntity(id: UUID().uuidString, uuid: "customId_\(idx)",title: "样式\(idx)")
    }
    
    func entities(for identifiers: [String]) async throws -> [ControlWidgetButtonEntity] {
        return dataItems.filter({ entity in
            return identifiers.contains(entity.id)
        })
    }
    
    func entities(matching string: String) async throws -> IntentItemCollection<ControlWidgetButtonEntity> {
       
   
        let reslutItems =  dataItems.filter({ item in
            return (item.title ?? "").contains(string)
        })
        return .init(items: reslutItems)
    }
    
    func suggestedEntities() async throws -> IntentItemCollection<ControlWidgetButtonEntity> {
        return .init(items: dataItems)
    }
    
    
    /// 官方及现有网上教程是用一个函数来异步获取保存的配置信息，但实际是选择后,数据不会同步
    private func getItems()  async throws -> [ControlWidgetButtonEntity]{
        return dataItems
    }
}

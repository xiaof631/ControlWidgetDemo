//
//  ControlWidgetButtonEntity.swift
//  MuWaWidgets
//
//  Created by user on 28/10/2024.
//

import AppIntents
import UIKit

// 自定义控制中心选择列表
@available(iOS 18.0, *)
struct ControlWidgetButtonEntity: AppEntity {
    
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "选择启动组件")

    static let defaultQuery = ControlWidgetButtonEntityQuery()

    var id:String
    var uuid:String
    var title:String?
 

    var displayRepresentation: DisplayRepresentation {
        let title = widgetModel?.name ?? controlModel?.enabledData?.title ?? "启动组件"
        var subTitle = "还未选择启动组件"
        var iconName =  "hand_tap"
        if let _model = controlModel?.enabledData{
            subTitle = "\(_model.title ?? "启动组件")/\(_model.subTitle ?? "")"
            iconName = _model.iconName ?? "hand_tap"
        }
        let themeColor = controlModel?.enabledData?.themeUIColor ?? .black
        
        let imageIcon = UIImage(named: iconName)?.withTintColor(themeColor, renderingMode: .alwaysOriginal)
        
        if let _iconData = imageIcon?.pngData(){
            return DisplayRepresentation(title: "\(title)",subtitle: "\(subTitle)",image: .init(data: _iconData))
        }else{
            return DisplayRepresentation(title: "\(title)",subtitle: "\(subTitle)",image: .init(named: iconName,isTemplate: false))
        }
        
       
    }
    
    init(id: String, uuid: String,title:String? = nil) {
        self.id = id
        self.uuid = uuid
        self.title = title
      
    }
    
    var widgetModel:WidgetModel?{
        let model = WidgetModel.load(with: self.uuid, sizeType: .controlSmall)
        return model
    }
    
    var controlModel:ControlWidgetData?{
        let model = widgetModel?.contentModel()?.controlModel
        return model
    }
    
}

@available(iOS 18.0, *)
struct ControlWidgetButtonEntityQuery: EntityQuery,EntityStringQuery {
  
    
    let items = WidgetDataManager.share.getControlUUids(.button).map({ uuid in
        ControlWidgetButtonEntity(id: UUID().uuidString, uuid: uuid)
    })
    
    func entities(for identifiers: [String]) async throws -> [ControlWidgetButtonEntity] {
        return items.filter({ entity in
            return identifiers.contains(entity.id)
        })
    }
    
    func entities(matching string: String) async throws -> IntentItemCollection<ControlWidgetButtonEntity> {
        
        var items:[ControlWidgetButtonEntity] = []
        let models = WidgetDataManager.share.loadAllWidgetData(.controlSmall)
        models.forEach { model in
            if model.controlType == .button{
                var entity = ControlWidgetButtonEntity(id: UUID().uuidString, uuid: model.uuid)
                entity.title = model.name
                items.append(entity)
            }
        }
        let reslutItems =  items.filter({ item in
            return (item.title ?? "").contains(string)
        })
        return .init(items: reslutItems)
    }
    
    
    
    func suggestedEntities() async throws -> IntentItemCollection<ControlWidgetButtonEntity> {
        return .init(items: items)
    }

}


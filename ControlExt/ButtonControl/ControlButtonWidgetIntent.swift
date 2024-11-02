//
//  ControlButtonWidgetIntent.swift
//  ControlWidgetDemo
//
//  Created by user on 2/11/2024.
//

import SwiftUI
import AppIntents
import ActivityKit


@available(iOS 18.0, *)
struct ControlButtonWidgetIntent:AppIntent,OpensIntent {

    var value: Never?
    
    
    init() {
        
    }

    /// 此参数需要设为True否则不会打开主App，则应用跳转失效
    static var openAppWhenRun: Bool = true
    
    static var title: LocalizedStringResource = "ControlButtonWidgetIntent"
    
    @Parameter(
        title: .init("widgets.controls.ControlWidgetButtonIntent.uuid", defaultValue: "uuid")
    )
    var uuid:String?
    
    init(uuid:String?){
        self.uuid = uuid
    }
 

    
    private func openSchemeUrl1(){
        EnvironmentValues().openURL(URL(string: "weixin://")!)
    }
    
    
    private func openSchemeUrl2(){
        // 需要自定义一个配置 UIApplication 只有主工程才能调用
        //#if MainApp
        //            await UIApplication.shared.open(URL(string: "weixin://")!)
        //#endif
    }
    
    private func openHttpUrls(){
        
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        let _url = "weixin://"
        if let URL = URL(string: _url){
            // 方法一
            openSchemeUrl1()
            
            // 方法2
            openSchemeUrl2()
            
            
            // 现有网上都指导使用此方法，但此方法只支持https的url格式，且会直接打开safari
//       return .result(opensIntent: OpenURLIntent(URL))
        }
        
        return .result(opensIntent: OpenURLIntent())
        
    }
    
}


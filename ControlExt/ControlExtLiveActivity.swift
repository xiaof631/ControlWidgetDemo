//
//  ControlExtLiveActivity.swift
//  ControlExt
//
//  Created by user on 2/11/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ControlExtAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ControlExtLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ControlExtAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ControlExtAttributes {
    fileprivate static var preview: ControlExtAttributes {
        ControlExtAttributes(name: "World")
    }
}

extension ControlExtAttributes.ContentState {
    fileprivate static var smiley: ControlExtAttributes.ContentState {
        ControlExtAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ControlExtAttributes.ContentState {
         ControlExtAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ControlExtAttributes.preview) {
   ControlExtLiveActivity()
} contentStates: {
    ControlExtAttributes.ContentState.smiley
    ControlExtAttributes.ContentState.starEyes
}

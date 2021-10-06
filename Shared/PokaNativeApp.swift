//
//  PokaNativeApp.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI

@main
struct PokaNativeApp: App {
    var body: some Scene {
        let windowView = WindowGroup {
            ContentView()
        }
        #if os(iOS)
        return windowView        
        #else
        return windowView.windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}

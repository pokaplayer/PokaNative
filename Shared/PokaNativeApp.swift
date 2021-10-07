//
//  PokaNativeApp.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
let defaults = UserDefaults.standard
@main
struct PokaNativeApp: App {
    
    @State var showLogin = true
    var body: some Scene {
        let windowView = WindowGroup {
            if showLogin {
                    Login(showLogin: self.$showLogin)
            } else {
                if UIDevice.isIPhone {
                    ContentViewiOS()
                } else {
                    ContentView()
                }
            }
        }
        #if os(iOS)
            return windowView
        #else
            return windowView.windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}

//
//  PokaNativeApp.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
import SwiftUIX

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

let defaults = UserDefaults.standard
let player = PPPlayer.shared
let LyricParser = PokaLyricParser.shared
@main
struct PokaNativeApp: App {
    @State var showLogin = true
    var body: some Scene {
        WindowGroup {
            if showLogin {
                Login(showLogin: self.$showLogin)
            } else {
                if UIDevice.isIPhone {
                    ContentViewiOS()
                } else {
                    ContentView()   .background(Color.clear)
                }
            }
        }
    }
}

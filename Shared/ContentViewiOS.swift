//
//  ContentViewiOS.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/7.
//

import SwiftUI

let blurEffect = UIBlurEffect(style: .systemMaterial)
struct ContentViewiOS: View {
    @State private var tabBarHeight: CGFloat = .zero

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            NavigationView { Home() }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Library()
                .tabItem {
                    Label("Library", systemImage: "rectangle.stack")
                }
            NavigationView { SearchView() }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            NavigationView { SettingView() }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            MiniPlayerView()
                .frame(height: 64, alignment: .bottomLeading)
                .ignoresSafeArea(.all)
        }
    }
}

struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}

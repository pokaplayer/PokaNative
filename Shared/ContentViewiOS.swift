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
    @State private var showPlayerOverlay = false

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
        .sheet(isPresented: $showPlayerOverlay) {
            PlayerControllerView()
        }

        .safeAreaInset(edge: .bottom, spacing: 0) {
            MiniPlayerView()
                .frame(height: 64, alignment: .bottomLeading)
                .onTapGesture {
                    showPlayerOverlay = true
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            if abs(value.translation.width) < abs(value.translation.height) {
                                if value.translation.height < 0 {
                                    showPlayerOverlay = true
                                }

                                if value.translation.height > 0 {
                                    // down
                                }
                            }
                        }
                )
                .ignoresSafeArea(.all)
        }
    }
}

struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}

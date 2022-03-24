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
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
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
            MiniPlayerView()
                .background(.systemGray6)
                .onTapGesture {
                    self.showPlayerOverlay = true
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width < 0 {
                            // left
                        }

                        if value.translation.width > 0 {
                            // right
                        }
                        if value.translation.height < 0 {
                            self.showPlayerOverlay = true
                        }

                        if value.translation.height > 0 {
                            // down
                        }
                    })
        }
    }
}

struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}

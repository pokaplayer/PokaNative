//
//  ContentViewiOS.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/7.
//

import SwiftUI 
struct ContentViewiOS: View {
    @State private var tabBarHeight: CGFloat = .zero
    @State private var showPlayerOverlay = false
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            TabView{
                Home()
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }
                Library()
                    .tabItem{
                        Label("Library", systemImage: "rectangle.stack")
                    }
                Text("Search")
                    .tabItem{
                        Label("Search", systemImage: "magnifyingglass")
                    }
                SettingView()
                    .tabItem{
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .sheet(isPresented: $showPlayerOverlay) {
                PlayerControllerView()
            }
            MiniPlayerView()
                .onTapGesture {
                    self.showPlayerOverlay = true
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
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
                }))
        }
    }
}

struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}

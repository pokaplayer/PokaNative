//
//  ContentViewiOS.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/7.
//

import SwiftUI

struct ContentViewiOS: View {
    var body: some View {
        VStack {
            TabView{
                Home()
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }
                Library()
                    .tabItem{
                        Label("Library", systemImage: "rectangle.stack")
                    }
                PlayerView()
                    .tabItem{
                        Label("Player", systemImage: "music.note")
                    }
                Text("Search")
                    .tabItem{
                        Label("Search", systemImage: "magnifyingglass")
                    }
                Text("Setting")
                    .tabItem{
                        Label("Setting", systemImage: "gearshape")
                    }
            } 
        }
    }
}

struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}

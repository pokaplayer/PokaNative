//
//  ContentView.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
struct ContentView: View {
    @State private var selectedView: Int? = 0
    @State var showLogin = false
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List (selection: $selectedView){
                    Button(action: {
                        showLogin = true
                    }) {
                        Label("Login", systemImage: "person")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: Home()) {
                        Label("Home", systemImage: "house")
                    }.tag(0)
                    .padding( 5.0)
                    NavigationLink(destination: Albums()) {
                        Label("Albums", systemImage: "opticaldisc")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: Text("Folders")) {
                        Label("Folders", systemImage: "folder")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: Text("Artists")) {
                        Label("Artists", systemImage: "music.mic")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: Text("Composers")) {
                        Label("Composers", systemImage: "pencil")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: Text("Playlists")) {
                        Label("Playlists", systemImage: "music.note.list")
                    }
                    .padding( 5.0)
                }
            }
            Home()
        }.sheet(isPresented: $showLogin, content: {
            Login(showLogin: self.$showLogin)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

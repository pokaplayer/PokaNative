//
//  ContentView.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
struct ContentView: View {
    @State private var selectedView: Int? = 0
    
    @StateObject private var ppplayer = player
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List (selection: $selectedView){
                    NavigationLink(destination: Home()) {
                        Label("Home", systemImage: "house")
                    }.tag(0)
                        .padding(5.0)
                    NavigationLink(destination: SearchView()) {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .padding(5.0)
                    NavigationLink(destination: AlbumsView()) {
                        Label("Albums", systemImage: "opticaldisc")
                    }
                    .padding(5.0)
                    NavigationLink(destination: FolderView()) {
                        Label("Folders", systemImage: "folder")
                    }
                    .padding(5.0)
                    NavigationLink(destination: ArtistView()) {
                        Label("Artists", systemImage: "music.mic")
                    }
                    .padding(5.0)
                    NavigationLink(destination: ComposerView()) {
                        Label("Composers", systemImage: "pencil")
                    }
                    .padding(5.0)
                    NavigationLink(destination: PlaylistsView()) {
                        Label("Playlists", systemImage: "music.note.list")
                    }
                    .padding(5.0)
                    NavigationLink(destination: SettingView()) { 
                        Label("Settings", systemImage: "gearshape")
                    }
                    .padding(5.0)
                    if player.currentPlayingItem != nil {
                        NavigationLink(destination: PlayerControllerView()) {
                            Label("Player", systemImage: "play")
                        }
                        .padding(5.0)
                    }
                }
            }.navigationTitle("PokaPlayer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

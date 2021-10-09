//
//  ContentView.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
struct ContentView: View {
    @State private var selectedView: Int? = 0
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List (selection: $selectedView){ 
                    NavigationLink(destination: Home()) {
                        Label("Home", systemImage: "house")
                    }.tag(0)
                        .padding( 5.0)
                    NavigationLink(destination: AlbumsView()) {
                        Label("Albums", systemImage: "opticaldisc")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: FolderView()) {
                        Label("Folders", systemImage: "folder")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: ArtistView()) {
                        Label("Artists", systemImage: "music.mic")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: ComposerView()) {
                        Label("Composers", systemImage: "pencil")
                    }
                    .padding( 5.0)
                    NavigationLink(destination: PlaylistsView()) {
                        Label("Playlists", systemImage: "music.note.list")
                    }
                    .padding( 5.0)
                }
            }
            Home()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

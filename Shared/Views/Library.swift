//
//  Library.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/7.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            HStack {
                List {
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
                }
                Spacer()

            }.navigationTitle("Library")
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

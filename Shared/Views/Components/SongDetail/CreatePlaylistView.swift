//
//  CreatePlaylistView.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/11/1.
//

import SwiftUI

struct CreatePlaylistView: View {
    @State var playlistName: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                TextField("Playlist name", text: $playlistName)
                    .textFieldStyle(LoginTextFieldStyle())
            }
            .padding(.horizontal, 10.0)
            Spacer()
        }
        .navigationTitle("Create playlist")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Button(action: {
                    self.dismiss()
                }) {
                    Text("Cancel")
                }
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: {
                    createPlaylist()
                }) {
                    Text("Create")
                }
            }
        }
    }

    func createPlaylist() {
        if playlistName != "" {
            PokaAPI.shared.createPlaylist(name: playlistName) { () in
                self.dismiss()
            }
        }
    }
}

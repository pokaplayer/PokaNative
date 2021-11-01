//
//  CreatePlaylistView.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/11/1.
//

import SwiftUI

struct CreatePlaylistView: View {
    @State var playlistName: String =  ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            TextField("Playlist name", text: $playlistName)
                .textFieldStyle(LoginTextFieldStyle())
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .navigationTitle("Create playlist")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Button(action: {
                    self.dismiss()
                }){
                    Text("Cancel")
                }
            }
            ToolbarItemGroup(placement: .primaryAction) {
            Button(action: {
                createPlaylist()
            }){
                Text("Create")
            }
            }
        }
    }
    func createPlaylist(){
        if self.playlistName != "" {
            PokaAPI.shared.createPlaylist(name: self.playlistName) { () in
                self.dismiss()
            }
        }
    }
}


//
//  SongPlaylistView.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/31.
//

import SwiftUI

struct SongPlaylistView: View {
    let item: Song
    @State var resData: ExistsInPlaylist?
    @State var showCreatePlaylistSheet = false
    var body: some View {
        VStack{
            if resData != nil {
                List{
                    ForEach(resData!.playlists, id: \.self) { item in
                        Button(action: {
                            addSongToPlaylist(id: item.id)
                        }){
                            HStack{
                                if resData!.existsPlaylists.contains(item) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .padding()
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                } else {
                                    Image(systemName: "circle")
                                        .padding()
                                        .foregroundColor(.gray)
                                        .frame(width: 24, height: 24)
                                        .opacity(0.5)
                                }
                                Text(item.name)
                                
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            } else {
                ProgressView()
            }
        }
        .sheet(isPresented: $showCreatePlaylistSheet, onDismiss: { fetchSongExistsData() }) {
            NavigationView {
                CreatePlaylistView()
            }
        }
        .onAppear() {
            fetchSongExistsData()
        }
        .navigationTitle("Add to playlist")
        .toolbar {
            Button(action: { self.showCreatePlaylistSheet = true }) {
                Text("Create")
            }
        }
    }
    func addSongToPlaylist(id: String){
        PokaAPI.shared.addSongToPlaylist(song: item, playlistId:  id ){ () in
            fetchSongExistsData()
        }
    }
    func fetchSongExistsData(){
        PokaAPI.shared.getIsSongExists(song: item) { (result) in
            self.resData = result
        }
    }
}


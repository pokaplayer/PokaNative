//
//  PlaylistView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/9.
//

import SwiftUI

struct PlaylistView: View {
    var playlist: Playlist
    @State private var resData = [Song]()
    var baseURL = defaults.string(forKey: "baseURL") ?? ""
    var body: some View {
        
        List{
            VStack{
                PlaylistCoverView(coverURL: playlist.image ?? "/img/icons/apple-touch-icon.png", size: 200)
                    .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                Text(playlist.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                HStack  {
                    Spacer()
                }
                SongView(songs: resData)
            }
            .listRowSeparator(.hidden)
            .padding(.top, 10.0)
            
        }.onAppear() {
            PokaAPI.shared.getPlaylistSongs(playlistID: playlist.id, source: playlist.source) { (result) in
                self.resData = result
            }
        }
        
        .frame(maxWidth: .infinity)
        .navigationTitle("Playlist")
    }
}


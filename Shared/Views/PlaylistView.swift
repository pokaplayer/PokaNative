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
        List {
            VStack {
                PlaylistCoverView(coverURL: playlist.image ?? playlist.cover ?? "/img/icons/apple-touch-icon.png", size: 200)
                    .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                Text(playlist.name)
                    .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                Text("\(resData.count) songs")
                    .font(/*@START_MENU_TOKEN@*/ .body/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                    .opacity(0.5)
                HStack {
                    Spacer()
                }
            }
            .padding(.top, 10.0)

            SongView(songs: resData)
        }
        .padding(.bottom, player.currentPlayingItem != nil ? 56.0 : 0)
        .onAppear {
            PokaAPI.shared.getPlaylistSongs(playlistID: playlist.id, source: playlist.source) { result in
                self.resData = result
            }
        }.listStyle(GroupedListStyle())

        .frame(maxWidth: .infinity)
        .navigationTitle("Playlist")
    }
}

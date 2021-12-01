//
//  SearchResultView.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/28.
//

import SwiftUI

struct SearchResultView: View {
    var items: SearchReponse
    var body: some View {
        VStack(alignment: .leading) {
            if items.songs.count > 0 {
                Text("Songs")
                    .padding(.horizontal, 10.0)
                    .opacity(0.5)
                    .font(.caption)
                ScrollView {
                    ForEach(Array(items.songs.enumerated()), id: \.offset) { index, item in
                        SongItemView(item: item, items: items.songs, index: index)
                            .padding(.horizontal, 10.0)
                            .padding(.vertical, 2.5)
                    }
                }
                .frame(height: 300.0)
            }
            if items.albums.count > 0 {
                Text("Albums")
                    .padding(.horizontal, 10.0)
                    .opacity(0.5)
                    .font(.caption)
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(items.albums) { item in
                            AlbumItemView(item: item)
                                .frame(width: 150)
                        }
                    }
                    .padding(.horizontal, 10.0)
                }
            }
            if items.playlists.count > 0 {
                Text("Playlists")
                    .padding(.horizontal, 10.0)
                    .opacity(0.5)
                    .font(.caption)
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(items.playlists) { item in
                            VPlaylistItemView(playlist: item)
                                .frame(width: 150)
                        }
                    }
                    .padding(.horizontal, 10.0)
                }
            }
            if items.artists.count > 0 {
                Text("Artists")
                    .padding(.horizontal, 10.0)
                    .opacity(0.5)
                    .font(.caption)
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(items.artists) { item in
                            VArtistsView(item: item)
                                .frame(width: 150)
                        }
                    }
                    .padding(.horizontal, 10.0)
                }
            }
        }
    }
}

/*
 struct SearchResultView_Previews: PreviewProvider {
 static var previews: some View {
 //SearchResultView()
 }
 }
 */

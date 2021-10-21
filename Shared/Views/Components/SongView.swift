//
//  SongView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/9.
//

import SwiftUI

struct SongView: View {
    var songs: [Song]
    @State private var showSheet = false
    @State private var sheetSongIndex = 0
    var body: some View {
        ForEach(Array(songs.enumerated()), id: \.offset) { index, item in
            HStack{
                Button(action: {
                    player.setSongs(songs: songs)
                    player.setTrack(index: index)
                }) {
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                            Text(item.artist)
                                .font(.caption)
                                .opacity(0.75)
                        }
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                Button(action: {
                    showSongDetail(index: index)
                }) {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            SongDetailView(item: songs[sheetSongIndex])
        }
    }
    func showSongDetail(index: Int){
        self.sheetSongIndex = index
        self.showSheet = true
    }
}


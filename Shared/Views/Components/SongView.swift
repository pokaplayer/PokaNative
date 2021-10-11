//
//  SongView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/9.
//

import SwiftUI

struct SongView: View {
    var songs: [Song]
    var body: some View {
        ForEach(Array(songs.enumerated()), id: \.offset) { index, item in
            Button(action: {
                player.setSongs(songs: songs)
                player.setTrack(index: index)
            }) {
                VStack(alignment: .leading){
                    Text(item.name)
                    Text(item.artist)
                        .font(.caption)
                        .opacity(0.75)
                }
                
            }.buttonStyle(PlainButtonStyle())
        }
    }
}


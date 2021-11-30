//
//  MiniPlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/10.
//

import CachedAsyncImage
import SwiftUI
struct PokaMiniplayer: View {
    @StateObject private var ppplayer = player
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                CachedAsyncImage(url: URL(string: PokaURLParser(player.currentPlayingItem!.song.cover))) { image in
                    image.resizable()
                } placeholder: {
                    ZStack {
                        VStack {
                            Rectangle()
                                .fill(Color.black.opacity(0))
                                .aspectRatio(1.0, contentMode: .fit)
                            Spacer()
                        }
                        ProgressView()
                    }
                }
                .frame(width: 55, height: 55)
                .cornerRadius(8.0)
                .aspectRatio(1, contentMode: .fill)
                VStack(alignment: .leading) {
                    Text(player.currentPlayingItem!.song.name)
                        .font(/*@START_MENU_TOKEN@*/ .headline/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(player.currentPlayingItem!.song.artist)
                        .font(.subheadline)
                        .opacity(0.75)
                        .lineLimit(1)
                }
                Spacer()
                Button(action: { player.isPaused ? player.playTrack() : player.pause() }) {
                    Image(systemName: player.isPaused ? "play" : "pause")
                        .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                        .frame(width: 36, height: 36)
                }.buttonStyle(PlainButtonStyle())
                Button(action: { player.nextTrack() }) {
                    Image(systemName: "forward.end.alt")
                        .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                        .frame(width: 36, height: 36)
                }.buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            Spacer()
        }
        .background(.systemGray6)
    }
}

struct MiniPlayerView: View {
    @StateObject private var ppplayer = player
    var body: some View {
        if player.currentPlayingItem != nil {
            if UIDevice.isIPhone {
                PokaMiniplayer()
                    .frame(height: 56)
                    .offset(y: -56)
            } else {
                PokaMiniplayer()
            }
        }
    }
}

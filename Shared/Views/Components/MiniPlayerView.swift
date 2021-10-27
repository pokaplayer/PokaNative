//
//  MiniPlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/10.
//

import SwiftUI

struct MiniPlayerView: View {
    
    @StateObject private var ppplayer = player
    var body: some View {
        if player.currentPlayingItem != nil {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    AsyncImage(url: URL(string: baseURL + player.currentPlayingItem!.song.cover) ){ image in
                        image.resizable()
                    } placeholder: {
                        ZStack{
                            VStack {
                                Rectangle()
                                    .fill(Color.black.opacity(0.2))
                                    .aspectRatio(1.0, contentMode: .fit)
                                Spacer()
                            }
                            ProgressView()
                        }
                    }
                    .frame(width: 55, height: 55)
                    .cornerRadius(8.0)
                    .aspectRatio(1, contentMode: .fill)
                    VStack(alignment: .leading){
                        
                        Text(player.currentPlayingItem!.song.name)
                            .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Text(player.currentPlayingItem!.song.artist)
                            .font(.subheadline)
                            .opacity(0.75)
                            .lineLimit(1)
                    }
                    Spacer()
                    Button(action: { ppplayer.isPaused ? player.playTrack() : player.pause() }) {
                        Image(systemName: ppplayer.isPaused ? "play" :"pause")
                            .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                            .frame(width: 36, height: 36)
                    }.buttonStyle(PlainButtonStyle())
                    Button(action: {player.nextTrack()}) {
                        Image(systemName: "forward.end.alt")
                            .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                            .frame(width: 36, height: 36)
                    }.buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(.regularMaterial)  
            .frame(height: 56)
            .offset(y: -56)
        }
    }
}


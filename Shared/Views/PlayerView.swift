//
//  PlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import SwiftUI

struct PlayerView: View {
    @StateObject private var ppplayer = player
    var body: some View {
        if (ppplayer.currentPlayingItem != nil) {
            VStack{
                VStack{
                    if #available(iOS 15.0, *) {
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
                        .frame(width: 200, height: 200)
                        .cornerRadius(5)
                        .aspectRatio(1, contentMode: .fill)
                        .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                    }
                    Text(player.currentPlayingItem!.song.name)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text(player.currentPlayingItem!.song.artist)
                        .font(.caption)
                        .foregroundColor(Color.black.opacity(0.75))
                        .multilineTextAlignment(.center)
                    HStack  {
                        Spacer()
                        Button(action: {player.previousTrack()}) {
                            Image(systemName: "backward.end.alt")
                        }
                        if ppplayer.timeControlStatus == .playing{
                            Button(action: { player.pause() }) {
                                Image(systemName: "pause")
                            }
                        } else if ppplayer.timeControlStatus == .paused {
                            Button(action: { player.playTrack() }) {
                                Image(systemName: "play")
                            }
                        } else {
                            Button(action: { player.playTrack() }) {
                                Image(systemName: "play")
                            }
                        }
                        Button(action: {player.nextTrack()}) {
                            Image(systemName: "forward.end.alt")
                        }
                        Spacer()
                    }
                }
                List {
                    ForEach(Array(ppplayer.playerItems.enumerated()), id: \.offset) { index, item in
                        Button(action: {
                            player.switchTrack(index: index)
                        }){
                            VStack(alignment: .leading){
                                Text(item.song.name)
                                Text(item.song.artist)
                                    .font(.caption)
                                    .foregroundColor(Color.black.opacity(0.75))
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 5.0)
                } .listStyle(GroupedListStyle())
            }
        } else{
            Text("No songs in queue")
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

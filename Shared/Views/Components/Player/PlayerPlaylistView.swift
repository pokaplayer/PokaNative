//
//  PlayerPlaylistView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/19.
//

import SwiftUI
struct PlayingIconView: View {
    var currentTrack: Int
    var songIndex: Int
    var body: some View {
        if songIndex == currentTrack {
            Image(systemName: "play.fill")
                .font(.system(size: 12)) 
                .foregroundColor(Color.white)
        }
    }
}
struct PlayerPlaylistView: View {
    @StateObject private var ppplayer = player
    var body: some View {
        ScrollViewReader { value in
            List {
                ForEach(Array(ppplayer.playerItems.enumerated()), id: \.element.id) { index, item in
                    Button(action: {
                        player.setTrack(index: index)
                        player.seek(to: 0)
                        withAnimation{
                            value.scrollTo(ppplayer.currentTrack, anchor: .center)
                        }
                    }){
                        HStack{
                            PlayingIconView(currentTrack: ppplayer.currentTrack, songIndex: index)
                            VStack(alignment: .leading){
                                Text(item.song.name)
                                    .foregroundColor(Color.white)
                                Text(item.song.artist)
                                    .font(.caption)
                                    .foregroundColor(Color.white)
                                    .opacity(0.75)
                            }
                        }
                    }
                    .id(index)
                    .buttonStyle(PlainButtonStyle())
                    .swipeActions {
                        Button("Delete") {
                            print("Right on!")
                            ppplayer.playerItems.remove(at: index)
                        }
                        .tint(.red)
                        
                    }
                    .listRowBackground(Color.clear)
                    .listSectionSeparatorTint(Color.clear)
                    .listRowSeparatorTint(Color.white.opacity(0.25))
                    
                }
                .padding(.horizontal, 5.0)
                .onAppear(perform: {
                    withAnimation{
                        value.scrollTo(ppplayer.currentTrack, anchor: .center)
                    }
                })
            }
            .listStyle(GroupedListStyle())
            .background(Color.clear)
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = .clear
            })
            .onDisappear(perform: {
                UITableView.appearance().backgroundColor = UIColor.systemGroupedBackground
            })
        }
    }
}

struct PlayerPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPlaylistView()
    }
}

//
//  PlayerPlaylistView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/19.
//

import SwiftUI

struct PlayerPlaylistView: View {
    @StateObject private var ppplayer = player
    var body: some View {
        
        UITableView.appearance().backgroundColor = .clear
        return List {
            Text("Playlist")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .listRowBackground(Color.clear)
                .listSectionSeparatorTint(Color.clear)
                .listRowSeparatorTint(Color.white.opacity(0.25))
            ForEach(Array(ppplayer.playerItems.enumerated()), id: \.element.id) { index, item in
                Button(action: {
                    player.setTrack(index: index)
                }){
                    VStack(alignment: .leading){
                        Text(item.song.name)
                            .foregroundColor(Color.white)
                        Text(item.song.artist)
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .opacity(0.75)
                    }
                }
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
        } .listStyle(GroupedListStyle())
            .background(Color.clear)
            .onDisappear(perform: {
                UITableView.appearance().backgroundColor = UIColor.systemGroupedBackground
            })
        
    }
}

struct PlayerPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPlaylistView()
    }
}

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
        UITableViewCell.appearance().backgroundColor = .clear
        return List {
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
                .listRowBackground(Color.clear)
                .listSectionSeparatorTint(Color.white.opacity(0.25))
                .listRowSeparatorTint(Color.white.opacity(0.25))
                .swipeActions {
                    Button("Delete") {
                        print("Right on!")
                        ppplayer.playerItems.remove(at: index)
                    }
                    .tint(.red)
                    
                }
                
            }
            .padding(.horizontal, 5.0)
        } .listStyle(GroupedListStyle())
        
        
    }
}

struct PlayerPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPlaylistView()
    }
}

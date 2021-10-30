//
//  PlayerPlaylistView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/19.
//

import SwiftUI 
struct PlayingItemView: View {
    var item: PPPlayerItem
    var currentTrack: Int
    var songIndex: Int
    var readerVal: ScrollViewProxy
    
    var body: some View {
        HStack{
            if songIndex == currentTrack {
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white)
                    .onAppear(perform: {
                        withAnimation{
                            readerVal.scrollTo(currentTrack, anchor: .center)
                        }
                    })
            } else {
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white)
                    .opacity(0) 
            }
            VStack(alignment: .leading){
                Text(item.song.name)
                    .foregroundColor(Color.white)
                Text(item.song.artist)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .opacity(0.75)
            }
            Spacer()
        }
        .padding(.all, 10)
        .background(songIndex == currentTrack ? .black.opacity(0.1) : .clear)
        .cornerRadius(10)
        
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
                    }){
                        PlayingItemView(
                            item: item,
                            currentTrack: ppplayer.currentTrack,
                            songIndex: index,
                            readerVal: value
                        )
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
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init())
                    
                }
                .padding(.horizontal, 5.0)
            }
            .listStyle(PlainListStyle())
            .onAppear(perform: {
                withAnimation{
                    value.scrollTo(ppplayer.currentTrack, anchor: .center)
                }
            })
        }
    }
}

struct PlayerPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPlaylistView()
    }
}

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
    @State var showPlaylistSheet = false
    var body: some View {
        HStack {
            if songIndex == currentTrack {
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white)
                    .onAppear(perform: {
                        withAnimation {
                            readerVal.scrollTo(currentTrack, anchor: .center)
                        }
                    })
            } else {
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white)
                    .opacity(0)
            }
            VStack(alignment: .leading) {
                Text(item.song.name)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                Text(item.song.artist)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .opacity(0.75)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 10)
        .padding(.vertical, 12.0)
        .background(songIndex == currentTrack ? .gray.opacity(0.25) : .clear)
        .cornerRadius(10)
        .sheet(isPresented: $showPlaylistSheet) {
            SongDetailView(item: item.song)
        }
        .contextMenu {
            Group {
                Button(action: { player.setTrack(index: songIndex) }) {
                    HStack {
                        Image(systemName: "play")
                        Text("Play")
                    }
                }
                Button(action: { showPlaylistSheet = true }) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
                }
                Divider()
                Button(role: .destructive, action: { player.playerItems.remove(at: songIndex) }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                }
            }
        }
    }
}

struct PlayerPlaylistView: View {
    @StateObject private var ppplayer = player
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                ForEach(Array(ppplayer.playerItems.enumerated()), id: \.element.id) { index, item in
                    Button(action: {
                        player.setTrack(index: index)
                        player.seek(to: 0)
                    }) {
                        PlayingItemView(
                            item: item,
                            currentTrack: ppplayer.currentTrack,
                            songIndex: index,
                            readerVal: value
                        )
                    }
                    .id(index)
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 5.0)
                    .hoverEffect()
                }
                .onAppear(perform: {
                    withAnimation {
                        value.scrollTo(ppplayer.currentTrack, anchor: .center)
                    }
                })
            }
        }
    }
}

struct PlayerPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPlaylistView()
    }
}

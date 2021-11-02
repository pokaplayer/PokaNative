//
//  PlayerLyricView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/19.
//

import SwiftUI
struct PlayerLyricTextView: View {
    @StateObject private var lyricParser = LyricParser
    var currentLyricIndex: Int = -1
    var index: Int
    var item: LyricItem
    var isTranslatedlyric: Bool
    var body: some View {
        HStack{
            Text(item.text)
                .font(isTranslatedlyric ? .title2 : .title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 10.0)
                .padding(.top, isTranslatedlyric ? -10.0 : 0)
            Spacer()
        }
    }
}
struct PlayerLyricView: View {
    @StateObject private var ppplayer = player
    @StateObject private var lyricParser = LyricParser
    @State var gotLyric = false
    @State var currentLyricSongID = player.currentPlayingItem!.id
    @State var currentLyricIndex = 0
    let timeObserver = PlayerTimeObserver()
    var body: some View {
        VStack{
            HStack{
                Spacer()
            }
            if gotLyric {
                ScrollViewReader { value in
                    ScrollView{
                        ForEach(Array(lyricParser.lyricItems.enumerated()), id: \.element.id) { index, item in
                            if index == currentLyricIndex || ( lyricParser.lyricTranslated && index == currentLyricIndex + 1){
                                PlayerLyricTextView(
                                    currentLyricIndex: currentLyricIndex,
                                    index: index,
                                    item: item,
                                    isTranslatedlyric: currentLyricIndex % 2 != index % 2
                                )
                                    .id(index)
                            }  else {
                                PlayerLyricTextView(
                                    currentLyricIndex: currentLyricIndex,
                                    index: index,
                                    item: item,
                                    isTranslatedlyric: currentLyricIndex % 2 != index % 2
                                )
                                    .id(index)
                                    .opacity(0.5)
                            }
                        }
                    }
                    .onReceive(timeObserver.publisher) { time in
                        withAnimation{
                            var temp = self.currentLyricIndex
                            self.currentLyricIndex = lyricParser.getCurrentLineIndex(time: time)
                            if temp != self.currentLyricIndex {
                                value.scrollTo(self.currentLyricIndex, anchor: .center)
                            }
                        }
                    }
                }
                Spacer()
            } else {
                Spacer()
                Image(systemName: "magnifyingglass")
                Text("Searching...")
                    .font(.caption)
                Spacer()
            }
        }
        //
        .onReceive(timeObserver.publisher) { time in
            updateLyric(time: time)
        }
    }
    func updateLyric(time: Double){
        if self.currentLyricSongID != ppplayer.currentPlayingItem!.id {
            // get new lyric
            self.gotLyric = false
            self.currentLyricIndex = 0
            self.currentLyricSongID = ppplayer.currentPlayingItem!.id
        }
        if !gotLyric {
            getLyric()
            self.gotLyric = true
        }
    }
    func getLyric(){
        let currentPlayingItem = ppplayer.currentPlayingItem!.song
        PokaAPI.shared.getLyric(songID: currentPlayingItem.id, source: currentPlayingItem.source){ (result) in
            if result.lyrics.count > 0 {
                lyricParser.loadLyric(lyric: result.lyrics[0].lyric)
            } else {
                searchLyric()
            }
        }
    }
    func searchLyric(){
        
    }
}

struct PlayerLyricView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLyricView()
    }
}

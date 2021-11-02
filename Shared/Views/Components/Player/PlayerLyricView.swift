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
        if item.text != "" {
            HStack{
                Text(item.text)
                    .font(isTranslatedlyric ? .title2 : .title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 10.0)
                    .padding(.horizontal, 20.0)
                    .padding(.top, isTranslatedlyric ? -10.0 : 0)
                Spacer()
            }
        }
    }
}
struct PlayerLyricView: View {
    @StateObject private var ppplayer = player
    @StateObject private var lyricParser = LyricParser
    @State var gotLyric = false
    @State var showLyricSheet = false
    @State var currentLyricSongID = UUID()
    @State var currentLyricIndex = 0
    @State var lyricSearchResult: [Lyric] = []
    
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
                                    isTranslatedlyric: lyricParser.lyricTranslated && currentLyricIndex % 2 != index % 2
                                )
                                    .id(index)
                            }  else {
                                PlayerLyricTextView(
                                    currentLyricIndex: currentLyricIndex,
                                    index: index,
                                    item: item,
                                    isTranslatedlyric: lyricParser.lyricTranslated && currentLyricIndex % 2 != index % 2
                                )
                                    .id(index)
                                    .opacity(0.5)
                            }
                        }
                    }
                    .onReceive(timeObserver.publisher) { time in
                        withAnimation(.easeInOut(duration: 0.2)){
                            let temp = self.currentLyricIndex
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
                ProgressView()
                Spacer()
            }
        }
        .onTapGesture(count: 2) {
            showLyricSheet = true
        }
        
        .sheet(isPresented: $showLyricSheet) {
            NavigationView{
                VStack{
                    if gotLyric {
                        if lyricSearchResult.count > 0 {
                            List{
                                Button(action: {
                                    lyricParser.loadLyric(lyric: "[00:00.000] No lyric :(")
                                    saveLyric(lyric: "[00:00.000] No lyric :(")
                                    self.showLyricSheet = false
                                }){
                                    VStack(alignment: .leading){
                                        Text("Don't load lyrics")
                                        Text("This will remove lyrics of the song now playing.")
                                    }
                                }.buttonStyle(PlainButtonStyle())
                                ForEach(lyricSearchResult, id: \.id) { item in
                                    Button(action: {
                                        lyricParser.loadLyric(lyric: item.lyric)
                                        saveLyric(lyric: item.lyric)
                                        self.showLyricSheet = false
                                    }){
                                        VStack(alignment: .leading){
                                            Text(item.name ?? "")
                                            Text(item.artist ?? "") + Text("(\(NSLocalizedString(item.source, comment: "")))")
                                        }
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            } 
                        } else {
                            Button(action: searchLyric, label: {
                                Text("Search")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            })
                                .padding(.vertical, 10)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(13)
                                .padding(.top, 20)
                                .padding(.bottom, 20)
                        }
                    } else {
                        ProgressView()
                    }
                }
                .navigationBarTitle("Search lyric")
                .toolbar {
                    Button(action: {
                        self.showLyricSheet = false
                    }){
                        Text("Cancel")
                    }
                }
            }
        }
        .onAppear(perform: {
            updateLyric()
        })
        .onReceive(timeObserver.publisher) { time in
            updateLyric()
        }
    }
    func updateLyric(){
        if self.currentLyricSongID != ppplayer.currentPlayingItem!.id {
            // get new lyric
            self.gotLyric = false
            self.currentLyricIndex = 0
            self.currentLyricSongID = ppplayer.currentPlayingItem!.id
            
            if !gotLyric {
                print("getLyric")
                getLyric()
            }
        }
    }
    func getLyric(){
        let currentPlayingItem = ppplayer.currentPlayingItem!.song
        PokaAPI.shared.getLyric(songID: currentPlayingItem.id, source: currentPlayingItem.source){ (result) in
            if result.lyrics.count > 0 {
                lyricParser.loadLyric(lyric: result.lyrics[0].lyric)
                self.gotLyric = true
            } else {
                searchLyric()
            }
        }
    }
    func searchLyric(){
        let currentPlayingItem = ppplayer.currentPlayingItem!.song
        self.gotLyric = false
        PokaAPI.shared.searchLyric(keyword: "\(currentPlayingItem.name) \(currentPlayingItem.artist)"){ (result) in
            if result.lyrics.count > 0 {
                lyricParser.loadLyric(lyric: result.lyrics[0].lyric)
                lyricSearchResult = result.lyrics
            } else {
                lyricParser.loadLyric(lyric: "[00:00.000] No lyric :(")
            }
            self.gotLyric = true
        }
    }
    func saveLyric(lyric: String){
        let currentPlayingItem = ppplayer.currentPlayingItem!.song
        PokaAPI.shared.saveLyric(
            title: currentPlayingItem.name,
            artist: currentPlayingItem.artist,
            songId: currentPlayingItem.id,
            source: currentPlayingItem.source,
            lyric: lyric
        ){ () in
            print("Lyric saved.")
        }
    }
}

struct PlayerLyricView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLyricView()
    }
}

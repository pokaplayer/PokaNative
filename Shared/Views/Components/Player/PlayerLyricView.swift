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
            HStack {
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
    @State private var searchText = ""
    let timeObserver = PlayerTimeObserver()
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            if gotLyric {
                ScrollViewReader { value in
                    ScrollView {
                        Rectangle()
                            .frame(height: 300.0)
                            .opacity(0)
                        ForEach(Array(lyricParser.lyricItems.enumerated()), id: \.element.id) { index, item in
                            if index == currentLyricIndex || (lyricParser.lyricTranslated && index == currentLyricIndex + 1) {
                                PlayerLyricTextView(
                                    currentLyricIndex: currentLyricIndex,
                                    index: index,
                                    item: item,
                                    isTranslatedlyric: lyricParser.lyricTranslated && currentLyricIndex % 2 != index % 2
                                )
                                .id(index)
                            } else {
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
                        Rectangle()
                            .frame(height: 300.0)
                            .opacity(0)
                    }
                    .mask(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .clear, location: .zero),
                                Gradient.Stop(color: .black, location: 0.1),
                                Gradient.Stop(color: .black, location: 0.9),
                                Gradient.Stop(color: .clear, location: 1),

                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .onReceive(timeObserver.publisher) { time in
                        withAnimation(.easeInOut(duration: 0.2)) {
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
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            let currentPlayingItem = ppplayer.currentPlayingItem!.song
            searchText = "\(currentPlayingItem.name) \(currentPlayingItem.artist)"

            showLyricSheet = true
        }

        .sheet(isPresented: $showLyricSheet) {
            NavigationView {
                VStack {
                    if gotLyric {
                        if lyricSearchResult.count > 0 {
                            List {
                                Button(action: {
                                    lyricParser.loadLyric(lyric: "[00:00.000]")
                                    saveLyric(lyric: "[00:00.000]")
                                    self.showLyricSheet = false
                                }) {
                                    VStack(alignment: .leading) {
                                        Text("Don't load lyrics")
                                        Text("This will remove lyrics of the song now playing.")
                                    }
                                }.buttonStyle(PlainButtonStyle())
                                ForEach(lyricSearchResult, id: \.id) { item in
                                    Button(action: {
                                        lyricParser.loadLyric(lyric: item.lyric)
                                        saveLyric(lyric: item.lyric)
                                        self.showLyricSheet = false
                                    }) {
                                        VStack(alignment: .leading) {
                                            Text(item.name ?? "")
                                            Text(item.artist ?? "") + Text("(\(NSLocalizedString(item.source, comment: "")))")
                                        }
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else {
                            VStack {
                                Button(action: searchLyric, label: {
                                    Text("Search")
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                })
                                .padding(.vertical, 10)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(13)
                                .padding(.all, 20)
                                Spacer()
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .onSubmit(of: .search) { // 1
                    print("submit searchLyricByKeyword")
                    searchLyricByKeyword(keyword: searchText)
                }
                .navigationBarTitle("Search")
                .toolbar {
                    Button(action: {
                        self.showLyricSheet = false
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
        .onAppear(perform: {
            updateLyric()
        })
        .onReceive(timeObserver.publisher) { _ in
            updateLyric()
        }
    }

    func updateLyric() {
        if currentLyricSongID != ppplayer.currentPlayingItem!.id {
            // get new lyric
            gotLyric = false
            currentLyricIndex = 0
            currentLyricSongID = ppplayer.currentPlayingItem!.id

            if !gotLyric {
                print("getLyric")
                getLyric()
            }
        }
    }

    func getLyric() {
        let currentPlayingItem = ppplayer.currentPlayingItem!.song
        PokaAPI.shared.getLyric(songID: currentPlayingItem.id, source: currentPlayingItem.source) { result in
            if result.lyrics.count > 0 {
                lyricParser.loadLyric(lyric: result.lyrics[0].lyric)
                self.gotLyric = true
            } else {
                searchLyric()
            }
        }
    }

    func searchLyric() {
        let currentPlayingItem = ppplayer.currentPlayingItem!.song
        searchText = "\(currentPlayingItem.name) \(currentPlayingItem.artist)"
        searchLyricByKeyword(keyword: searchText)
    }

    func searchLyricByKeyword(keyword: String) {
        gotLyric = false
        PokaAPI.shared.searchLyric(keyword: keyword) { result in
            if result.lyrics.count > 0 {
                lyricParser.loadLyric(lyric: result.lyrics[0].lyric)
                lyricSearchResult = result.lyrics
            } else {
                lyricParser.loadLyric(lyric: "[00:00.000] ._.")
            }
            self.gotLyric = true
        }
    }

    func saveLyric(lyric: String) {
        let currentPlayingItem = ppplayer.currentPlayingItem!.song
        PokaAPI.shared.saveLyric(
            title: currentPlayingItem.name,
            artist: currentPlayingItem.artist,
            songId: currentPlayingItem.id,
            source: currentPlayingItem.source,
            lyric: lyric
        ) { () in
            print("Lyric saved.")
        }
    }
}

struct PlayerLyricView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLyricView()
    }
}

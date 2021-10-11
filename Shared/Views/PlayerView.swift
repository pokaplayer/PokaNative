//
//  PlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import SwiftUI
import AVFoundation
import MediaPlayer

struct PPPlayerItem: Identifiable {
    var id = UUID()
    let title, songID, artist, artistID, album, albumID, songURL, coverURL: String
    let item: AVPlayerItem
    /*init(title: String, songID: String, artist: String, artistID: String, album: String, albumID: String, songURL: String, coverURL: String, item: AVPlayerItem){
     self.title = title
     self.songID = songID
     self.artist = artist
     self.artistID = artistID
     self.album = album
     self.albumID = albumID
     self.songURL = songURL
     self.coverURL = coverURL
     self.item = item
     }*/
}

class PPPlayer: AVPlayer, ObservableObject {
    static let shared = PPPlayer()
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.nextTrack),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        let center = MPRemoteCommandCenter.shared()
         
        center.previousTrackCommand.isEnabled = true
        center.previousTrackCommand.addTarget { event in
            self.previousTrack()
            return .success
        }
 
        center.nextTrackCommand.isEnabled = true
        center.previousTrackCommand.addTarget { event in
            self.nextTrack()
            return .success
        }
        
         
        center.playCommand.isEnabled = true
        center.playCommand.addTarget { event in
            self.playTrack()
            return .success
        }
 
        center.pauseCommand.isEnabled = true
        center.pauseCommand.addTarget { event in
            self.pause()
            return .success
        }
    }
    
    @Published var currentPlayingItem: PPPlayerItem?
    @Published var playerItems = [PPPlayerItem]()
    var currentTrack = 0
    
    
    private func initPlayerAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVURLAsset(url: url, options: [
            AVURLAssetHTTPCookiesKey: HTTPCookieStorage.shared.cookies!
        ])
        
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            completion?(asset)
        }
    }
    func add(song: Song){
        let tempCount = self.playerItems.count
        self.initPlayerAsset(with: URL(string: baseURL + song.url)!) { (asset: AVAsset) in
            let item = AVPlayerItem(asset: asset)
            self.playerItems.append(PPPlayerItem(title: song.name, songID: song.id, artist: song.artist, artistID: song.artistID ?? "", album: song.album, albumID: song.albumID ?? "", songURL: song.url, coverURL: song.cover, item: item))
            if tempCount == 0 {
                self.playTrack()
            }
        }
        
    }
    
    func playTrack() {
        if self.playerItems.count > 0 {
            replaceCurrentItem(with: self.playerItems[self.currentTrack].item)
            self.currentPlayingItem = self.playerItems[self.currentTrack]
            play()
            // update nowplaying
            
            let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
            var nowPlayingInfo = [String: Any]()
            
            nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue
            nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentPlayingItem!.title
            nowPlayingInfo[MPMediaItemPropertyArtist] = self.currentPlayingItem!.artist
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = self.currentPlayingItem!.album
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        }
    } 
    
    func previousTrack() {
        if self.currentTrack - 1 < 0 {
            self.currentTrack = (self.playerItems.count - 1) < 0 ? 0 : (self.playerItems.count - 1)
        } else {
            self.currentTrack -= 1
        }
        self.playTrack()
    }
    
    @objc func nextTrack() {
        if self.currentTrack + 1 > self.playerItems.count - 1 {
            self.currentTrack = 0
        } else {
            self.currentTrack += 1;
        }
        self.playTrack()
    }
}

struct PlayerView: View {
    @StateObject private var ppplayer = player 
    var body: some View {
        if (ppplayer.currentPlayingItem != nil) {
            VStack{
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: baseURL + player.currentPlayingItem!.coverURL) ){ image in
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
                Text(player.currentPlayingItem!.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text(player.currentPlayingItem!.artist)
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
                            VStack{
                                Image(systemName: "play")
                                Text("?")
                            }
                        }
                    }
                    Button(action: {player.nextTrack()}) {
                        Image(systemName: "forward.end.alt")
                    }
                    Spacer()
                }
                List(ppplayer.playerItems) { item in
                    VStack{
                        Text(item.title)
                        Text(item.artist)
                            .font(.caption)
                            .foregroundColor(Color.black.opacity(0.75))
                    }
                }
                Spacer()
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

//
//  PPPlayer.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/11.
//


import SwiftUI
import AVFoundation
import MediaPlayer

class PPPlayerItem: Identifiable {
    @Published var id = UUID()
    @Published var song: Song
    @Published var item: AVPlayerItem?
    init(song: Song){
        self.song = song
        
        player.initPlayerAsset(with: URL(string: baseURL + song.url)!) { [weak self] (asset: AVAsset) in
            DispatchQueue.main.async {
                let item = AVPlayerItem(asset: asset)
                self?.item = item
            }
        }
    }
}

class PPPlayer: AVPlayer, ObservableObject {
    static let shared = PPPlayer()
    private let nowPlayingCenter = MPNowPlayingInfoCenter.default()
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
        center.nextTrackCommand.addTarget { event in
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
        
        center.changePlaybackPositionCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            guard let positionEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            
            print("posion: \(positionEvent.positionTime)")
            self?.seek(to: CMTime(seconds: positionEvent.positionTime, preferredTimescale: CMTimeScale(1000)))
            
            return .success
        }
        // Configure the application’s shared audio instance
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    @Published var currentPlayingItem: PPPlayerItem?
    @Published var playerItems = [PPPlayerItem]()
    var currentTrack = 0
    
    func initPlayerAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVURLAsset(url: url, options: [
            AVURLAssetHTTPCookiesKey: HTTPCookieStorage.shared.cookies!
        ])
        
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            completion?(asset)
        }
    }
    let dispatchQueue = DispatchQueue(label: "concurrent.queue", qos: .utility, attributes: .concurrent)
    func add(songs: [Song], index: Int?){
        self.playerItems = [PPPlayerItem]()
        for i in 0...songs.count-1 {
            self.playerItems.append(PPPlayerItem(song: songs[i]))
        }
        self.currentTrack = index ?? 0
        self.playTrack()
        
    }
    
    func playTrack() {
        if self.playerItems.count > 0 {
            replaceCurrentItem(with: self.playerItems[self.currentTrack].item)
            self.currentPlayingItem = self.playerItems[self.currentTrack]
            play()
            
            // update nowplaying
            var info = [String: Any]()
            info[MPMediaItemPropertyTitle] = self.currentPlayingItem!.song.name
            info[MPMediaItemPropertyArtist] = self.currentPlayingItem!.song.artist
            info[MPMediaItemPropertyAlbumTitle] = self.currentPlayingItem!.song.album
            
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.currentItem?.currentTime().seconds
            info[MPMediaItemPropertyPlaybackDuration] = self.currentItem?.asset.duration.seconds
            info[MPNowPlayingInfoPropertyPlaybackRate] = self.rate
            
            DispatchQueue.global().async { [weak self] in
                if let artworkUrl = URL(string: baseURL + self!.currentPlayingItem!.song.cover),
                   let artworkData = try? Data(contentsOf: artworkUrl),
                   let artworkImage = UIImage(data: artworkData) {
                    if var currentInfo = self?.nowPlayingCenter.nowPlayingInfo {
                        currentInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artworkImage.size) { _ in artworkImage }
                        self?.nowPlayingCenter.nowPlayingInfo = currentInfo
                    }
                }
            }
            
            
            self.nowPlayingCenter.nowPlayingInfo = info
        }
    }
    func switchTrack(index: Int){
        self.currentTrack = index
        self.playTrack()
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


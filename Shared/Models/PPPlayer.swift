//
//  PPPlayer.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/11.
//


import SwiftUI
import AVFoundation
import MediaPlayer
import Combine


class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var timeObservation: Any?
    
    init() {
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(1000)), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
}


@objc class PPPlayerItem: NSObject, Identifiable, ObservableObject {
    @Published var id = UUID()
    @Published var song: Song
    @Published @objc dynamic var item: AVPlayerItem?
    var observer: NSKeyValueObservation?
    
    init(song: Song){
        self.song = song
        super.init()
    }
}

class PPPlayer: AVPlayer, ObservableObject {
    static let shared = PPPlayer()
    private let nowPlayingCenter = MPNowPlayingInfoCenter.default()
    
    @Published var currentPlayingItem: PPPlayerItem?
    @Published var playerItems = [PPPlayerItem]()
    @Published var isPaused: Bool = true
    var currentTrack = 0
    
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
            self!.seek(to: positionEvent.positionTime)
            
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
    
    func initPlayerAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVAsset(url: url)
        
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            completion?(asset)
        }
    }
    let dispatchQueue = DispatchQueue(label: "concurrent.queue", qos: .utility, attributes: .concurrent)
    
    private func getNowPlayingInfo() -> [String : Any]{
        let song = self.currentPlayingItem!.song
        let info = [
            MPMediaItemPropertyTitle:      song.name,
            MPMediaItemPropertyArtist:     song.artist,
            MPMediaItemPropertyAlbumTitle: song.album,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: self.currentItem?.currentTime().seconds ?? 0,
            MPMediaItemPropertyPlaybackDuration: self.currentItem?.asset.duration.seconds ?? 0,
            MPNowPlayingInfoPropertyPlaybackRate: self.rate
        ] as [String : Any]
        return info
    }
    
    override func play() {
        super.play()
        self.isPaused = false
        dispatchQueue.async { [weak self] in
            if let artworkUrl = URL(string: PokaURLParser(self!.currentPlayingItem!.song.cover)),
               let artworkData = try? Data(contentsOf: artworkUrl),
               let artworkImage = UIImage(data: artworkData) {
                if var currentInfo = self?.nowPlayingCenter.nowPlayingInfo {
                    currentInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artworkImage.size) { _ in artworkImage }
                    self?.nowPlayingCenter.nowPlayingInfo = currentInfo
                }
            }
        }
        self.nowPlayingCenter.nowPlayingInfo = getNowPlayingInfo()
    }
    override func pause() {
        super.pause()
        self.isPaused = true
        MPNowPlayingInfoCenter.default().playbackState = .paused
    }
    func seek(to: Double){
        super.seek(to: CMTime(seconds: to, preferredTimescale: CMTimeScale(1000)))
    }
    func playTrack() {
        if self.playerItems.count > 0 {
            print("playTrack")
            self.currentPlayingItem = self.playerItems[self.currentTrack]
            
            self.currentPlayingItem?.observer?.invalidate()
            self.currentPlayingItem?.observer = self.currentPlayingItem?.observe(
                \.item,
                 options: [.initial, .new],
                 changeHandler: {(playingItem, change) in
                     if playingItem.item != nil {
                         self.replaceCurrentItem(with: playingItem.item)
                         self.play()
                         
                         MPNowPlayingInfoCenter.default().playbackState = .playing
                     }
                 }
            )
        }
    }
    
    func setSongs(songs: [Song]){
        self.playerItems = [PPPlayerItem]()
        for i in 0...songs.count-1 {
            self.playerItems.append(PPPlayerItem(song: songs[i]))
        }
    }
    func addSong(song: Song){
        self.playerItems.append(PPPlayerItem(song: song))
        if self.isPaused {
            self.nextTrack()
        }
    }
    
    func setTrack(index: Int){
        self.currentTrack = index
        self.pause()
        // init item
        self.initPlayerAsset(with: URL(string: baseURL + self.playerItems[index].song.url + "&songRes=" + (defaults.string(forKey: "audioQuality") ?? "high"))!) { [weak self] (asset: AVAsset) in
            DispatchQueue.main.async {
                let item = AVPlayerItem(asset: asset)
                self?.playerItems[index].item = item
                self?.playTrack()
            }
        }
        
    }
    
    func previousTrack() {
        if self.currentTrack - 1 < 0 {
            self.setTrack(index: (self.playerItems.count - 1) < 0 ? 0 : (self.playerItems.count - 1))
        } else {
            self.setTrack(index: self.currentTrack - 1)
        }
        self.seek(to: 0)
    }
    
    @objc func nextTrack() {
        if self.currentTrack + 1 > self.playerItems.count - 1 {
            self.setTrack(index: 0)
        } else {
            self.setTrack(index: self.currentTrack + 1)
        }
        self.seek(to: 0)
        self.playTrack()
    }
}


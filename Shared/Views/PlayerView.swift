//
//  PlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import SwiftUI
import AVFoundation

class PPPlayer: AVPlayer {
    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.nextTrack),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    private var playerItems = [AVPlayerItem]()
    private var currentTrack = 0
    
    private func initPlayerAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        let asset = AVURLAsset(url: url, options: [
            AVURLAssetHTTPCookiesKey: HTTPCookieStorage.shared.cookies!
        ])

        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            completion?(asset)
        }
    }
    
    func add(url: URL){
        self.initPlayerAsset(with: url) { (asset: AVAsset) in
            let item = AVPlayerItem(asset: asset)
            self.playerItems.append(item)
        }
    }
    
    func playTrack() {
        if self.playerItems.count > 0 {
            replaceCurrentItem(with: self.playerItems[self.currentTrack])
            play()
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
        if self.currentTrack + 1 > self.playerItems.count {
            self.currentTrack = 0
        } else {
            self.currentTrack += 1;
        }

        self.playTrack()
    }
}
let player = PPPlayer()

struct PlayerView: View {
    var body: some View {
        List {
            Button(action: {player.playTrack()}) {
                Text("Play")
            }
            Button(action: {player.play()}) {
                Text("Resume")
            }
            Button(action: {player.pause()}) {
                Text("Pause")
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

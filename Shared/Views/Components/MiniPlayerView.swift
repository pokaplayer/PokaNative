//
//  MiniPlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/10.
//

import CachedAsyncImage
import SwiftUI

struct PlayerProgressView: View {
    @StateObject private var ppplayer = player
    let timeObserver = PlayerTimeObserver()
    @State private var currentTime: TimeInterval = 0
    @State private var duration: Double = 0
    @State private var progress: Double = 0
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Rectangle()
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width),height: 2.5)
                    .foregroundColor(.blue)
                    .onReceive(timeObserver.publisher) { time in
                        self.currentTime = time
                        self.duration = ppplayer.currentItem?.asset.duration.seconds ?? 0
                        self.progress = self.currentTime / self.duration
                    }
            }
        }
    }
}

struct PokaMiniplayer: View {
    @StateObject private var ppplayer = player
    var body: some View {
        VStack(alignment: .leading) {
            PlayerProgressView()
            Spacer()
            HStack {
                CachedAsyncImage(url: URL(string: PokaURLParser(player.currentPlayingItem!.song.cover))) { image in
                    image.resizable()
                } placeholder: {
                    ZStack {
                        VStack {
                            Rectangle()
                                .fill(Color.black.opacity(0))
                                .aspectRatio(1.0, contentMode: .fit)
                            Spacer()
                        }
                        ProgressView()
                    }
                }
                .frame(width: 55, height: 55)
                .cornerRadius(8.0)
                .aspectRatio(1, contentMode: .fill)
                VStack(alignment: .leading) {
                    Text(player.currentPlayingItem!.song.name)
                        .font(/*@START_MENU_TOKEN@*/ .headline/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(player.currentPlayingItem!.song.artist)
                        .font(.subheadline)
                        .opacity(0.75)
                        .lineLimit(1)
                }
                Spacer()
                Button(action: { player.isPaused ? player.playTrack() : player.pause() }) {
                    Image(systemName: player.isPaused ? "play" : "pause")
                        .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                        .frame(width: 36, height: 36)
                }.buttonStyle(PlainButtonStyle())
                Button(action: { player.nextTrack() }) {
                    Image(systemName: "forward.end.alt")
                        .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                        .frame(width: 36, height: 36)
                }.buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            Spacer()
        }
        .contentShape(Rectangle())
        .overlay(Divider(), alignment: .top)
    }
}

struct MiniPlayerView: View {
    @StateObject private var ppplayer = player
    @State private var keyboardShowed: Bool = false
    @State private var keyboardHiding: Bool = false
    var body: some View {
        VStack {
            if player.currentPlayingItem != nil {
                if UIDevice.isIPhone {
                    PokaMiniplayer()
                        .background(
                            ZStack {
                                Rectangle().fill(.regularMaterial)
                                Color.systemGray6.mask(LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: .black.opacity(0.5), location: .zero),
                                        Gradient.Stop(color: .black, location: 1),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                            }.ignoresSafeArea()
                        )
                        .frame(height: 56)
                        .offset(y: keyboardShowed ? -8 : -56)
                } else {
                    PokaMiniplayer()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            keyboardShowed = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardShowed = false
        }
    }
}

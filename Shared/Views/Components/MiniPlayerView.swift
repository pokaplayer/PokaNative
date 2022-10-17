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
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 2.5)
                    .foregroundColor(.accentColor)
                    .onReceive(timeObserver.publisher) { time in
                        self.currentTime = time
                        self.duration = ppplayer.currentItem?.asset.duration.seconds ?? 0
                        self.progress = self.currentTime / self.duration
                    }
            }
        }
    }
}

struct PlayerItemInfoView: View {
    var item: PPPlayerItem
    var body: some View {
        HStack(alignment: .center) {
            CachedAsyncImage(url: URL(string: PokaURLParser(item.song.cover))) { image in
                image.resizable()
            } placeholder: {
                ZStack {
                    Rectangle()
                        .fill(.white.opacity(0.1))
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 52, height: 52)
                    ProgressView()
                }
            }
            .frame(width: 52, height: 52)
            .cornerRadius(8.0)
            .aspectRatio(1, contentMode: .fill)
            VStack(alignment: .leading) {
                Text(item.song.name)
                    .font(/*@START_MENU_TOKEN@*/ .headline/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text(item.song.artist)
                    .font(.subheadline)
                    .opacity(0.75)
                    .lineLimit(1)
            }
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct PokaMiniplayer: View {
    @StateObject private var ppplayer = player
    @GestureState private var translation: CGFloat = 0
    @State var showPlayerOverlay = false
    @State var showPlayerSheet = false
    var body: some View {
        VStack(alignment: .leading) {
            PlayerProgressView()
            Spacer()
            HStack(alignment: .center) {
                GeometryReader { geometry in
                    LazyHStack(spacing: 0) {
                        PlayerItemInfoView(item: player.previousPlayItem!)
                            .frame(width: geometry.size.width)
                            .opacity(translation / geometry.size.width - 0.5)
                        PlayerItemInfoView(item: player.currentPlayingItem!)
                            .frame(width: geometry.size.width)
                        PlayerItemInfoView(item: player.nextPlayItem!)
                            .frame(width: geometry.size.width)
                            .opacity(-translation / geometry.size.width - 0.5)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                    .offset(x: -geometry.size.width)
                    .offset(x: translation)
                    .onTapGesture {
                        if UIDevice.isIPhone {
                            showPlayerSheet = true
                        } else {
                            showPlayerOverlay = true
                        }
                    }
                    .gesture(
                        DragGesture().updating($translation) { value, state, _ in
                            if abs(value.translation.width) > 10 {
                                withAnimation(.interactiveSpring()) {
                                    state = value.translation.width
                                }
                            }
                        }.onEnded { value in
                            if abs(value.translation.width) / geometry.size.width > 0.1 {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                if value.translation.width < 0 {
                                    ppplayer.nextTrack()
                                } else {
                                    ppplayer.previousTrack()
                                }
                            } else {
                                if value.translation.height < -10 {
                                    if UIDevice.isIPhone {
                                        showPlayerSheet = true
                                    } else {
                                        showPlayerOverlay = true
                                    }
                                }
                            }
                        }
                    )
                }

                Button(action: { player.isPaused ? player.playTrack() : player.pause() }) {
                    if player.isLoading {
                        ProgressView()
                            .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                            .frame(width: 36, height: 36)
                    } else {
                        Image(systemName: player.isPaused ? "play" : "pause")
                            .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                            .frame(width: 36, height: 36)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .hoverEffect()
                Button(action: { player.nextTrack() }) {
                    Image(systemName: "forward.end.alt")
                        .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(PlainButtonStyle())
                .hoverEffect()
            }
            .padding(.horizontal, 12.0)

            Spacer()
        }
        .overlay(Divider(), alignment: .top)
        .contentShape(Rectangle())
        .frame(height: 64)
        .sheet(isPresented: $showPlayerSheet) { PlayerControllerView() }
        .fullScreenCover(isPresented: $showPlayerOverlay, content: PlayerControllerView.init)
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
                        .offset(y: keyboardShowed ? 0 : -48)
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

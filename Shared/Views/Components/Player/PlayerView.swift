//
//  PlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import CachedAsyncImage
import Introspect
import SwiftUI
struct PlayerTimeView: View {
    @StateObject private var ppplayer = player
    let timeObserver = PlayerTimeObserver()
    @State private var currentTime: TimeInterval = 0
    @State private var duration: Double = 0
    var body: some View {
        VStack {
            Slider(
                value: Binding(get: {
                    Double(self.currentTime)
                }, set: { newVal in
                    ppplayer.seek(to: newVal)
                }),
                in: 0.0 ... duration
            )
            .introspectSlider { slider in
                slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
            }
            .accentColor(.white)
            HStack {
                Text(formatTime(seconds: currentTime))
                    .foregroundColor(Color.white)
                    .onReceive(timeObserver.publisher) { time in
                        self.currentTime = time
                        self.duration = ppplayer.currentItem?.asset.duration.seconds ?? 0
                    }
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                Spacer()
                Text(formatTime(seconds: duration))
                    .foregroundColor(Color.white)
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
            }
        }
        .padding(.horizontal, 20)
    }
}

struct PlayerCoverView: View {
    var coverURL: String
    var coverSize: CGFloat
    var body: some View {
        CachedAsyncImage(url: URL(string: PokaURLParser(coverURL))) { image in
            image.resizable()
                .scaledToFill()
                .frame(width: coverSize, height: coverSize)
                .clipped()
                .cornerRadius(8)
        } placeholder: {
            ZStack {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(width: coverSize, height: coverSize)
                    .cornerRadius(8)
                ProgressView()
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .center)
        .aspectRatio(1, contentMode: .fit)
        .padding(20.0)
        .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
    }
}

struct DurationTimeView: View {
    var body: some View {
        Text(formatTime(seconds: player.currentItem?.asset.duration.seconds ?? 0))
            .foregroundColor(Color.white)
    }
}

func formatTime(seconds: TimeInterval) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "mm:ss"
    return formatter.string(from: Date(timeIntervalSinceReferenceDate: TimeInterval(Int(seconds))))
}

struct PlayerView: View {
    @StateObject private var ppplayer = player
    @GestureState private var translation: CGFloat = 0
    @State private var coverSize: CGFloat = min(460, UIScreen.main.bounds.width - 40)
    var body: some View {
        if ppplayer.currentPlayingItem != nil {
            VStack {
                Spacer()
                GeometryReader { geometry in
                    LazyHStack(spacing: 0) {
                        PlayerCoverView(coverURL: player.previousPlayItem!.song.cover, coverSize: coverSize)
                            .frame(width: UIDevice.isIPhone ? UIScreen.main.bounds.size.width - 40 : 500.0)
                            .opacity(min(translation / geometry.size.width, 0.95))
                            .scaleEffect(min(1, translation / geometry.size.width + 0.5), anchor: .center)
                        PlayerCoverView(coverURL: player.currentPlayingItem!.song.cover, coverSize: coverSize)
                            .frame(width: UIDevice.isIPhone ? UIScreen.main.bounds.size.width - 40 : 500.0)
                            .scaleEffect(translation == 0 ? 1 : max(((80 - abs(translation)) / 80) * 0.2 + 0.8, 0.8), anchor: .center)
                            .opacity(translation == 0 ? 1 : 0.8)
                        PlayerCoverView(coverURL: player.nextPlayItem!.song.cover, coverSize: coverSize)
                            .frame(width: UIDevice.isIPhone ? UIScreen.main.bounds.size.width - 40 : 500.0)
                            .opacity(min(-translation / geometry.size.width, 0.95))
                            .scaleEffect(min(1, -translation / geometry.size.width + 0.5), anchor: .center)
                    }
                    .offset(x: -geometry.size.width + (UIDevice.isIPhone ? 40 * 1.5 : 0))
                    .offset(x: translation)
                    .gesture(
                        DragGesture().updating($translation) { value, state, _ in
                            if abs(value.translation.width) > 10 {
                                withAnimation(.interactiveSpring()) {
                                    state = value.translation.width
                                }
                            }
                        }.onEnded { value in
                            if abs(value.translation.width) > (coverSize / 2) {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                if value.translation.width < 0 {
                                    ppplayer.nextTrack()
                                } else {
                                    ppplayer.previousTrack()
                                }
                            }
                        }
                    )
                }
                .frame(height: coverSize)

                VStack(alignment: .leading) {
                    Text(player.currentPlayingItem!.song.name)
                        .font(/*@START_MENU_TOKEN@*/ .headline/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    Text(player.currentPlayingItem!.song.artist)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .opacity(0.75)
                    HStack {
                        Spacer()
                    }
                }.padding(.horizontal, 20).padding(.top, 32)
                PlayerTimeView()
                HStack {
                    Spacer()

                    Button(action: { player.shuffle() }) {
                        Image(systemName: "dice")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .hoverEffect()

                    Button(action: { player.previousTrack() }) {
                        Image(systemName: "backward.end.alt")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .hoverEffect()

                    Button(action: { ppplayer.isPaused ? player.playTrack() : player.pause() }) {
                        if player.isLoading {
                            ProgressView()
                                .font(/*@START_MENU_TOKEN@*/ .title3/*@END_MENU_TOKEN@*/)
                                .frame(width: 24, height: 24)
                        } else {
                            Image(systemName: ppplayer.isPaused ? "play" : "pause")
                                .font(.system(size: 24))
                                .padding()
                                .foregroundColor(Color.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 56, height: 56)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(.infinity)
                    .contentShape(RoundedRectangle(cornerRadius: 500, style: .continuous))
                    .hoverEffect()

                    Button(action: { player.nextTrack() }) {
                        Image(systemName: "forward.end.alt")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .hoverEffect()

                    Button(action: {}) {
                        Image(systemName: "forward.end.alt")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(0)

                    Spacer()
                }
                Spacer()
            }
        } else {
            Text("No songs in queue")
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}

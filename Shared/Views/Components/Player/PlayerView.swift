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
    @State var coverSize: CGFloat = min(460, UIScreen.main.bounds.width - 40)
    var body: some View {
        if ppplayer.currentPlayingItem != nil {
            VStack {
                VStack {
                    Spacer()

                    CachedAsyncImage(url: URL(string: PokaURLParser(player.currentPlayingItem!.song.cover))) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: coverSize, height: coverSize)
                            .clipped()
                            .cornerRadius(5)
                    } placeholder: {
                        ZStack {
                            Rectangle().opacity(0)
                            ProgressView()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(20.0)
                    .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)

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
                    }.padding(.horizontal, 20)
                    PlayerTimeView()
                    HStack {
                        Spacer()
                        Button(action: { player.previousTrack() }) {
                            Image(systemName: "backward.end.alt")
                                .font(.system(size: 20))
                                .padding()
                                .foregroundColor(Color.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .hoverEffect()
                        Button(action: { ppplayer.isPaused ? player.playTrack() : player.pause() }) {
                            Image(systemName: ppplayer.isPaused ? "play" : "pause")
                                .font(.system(size: 24))
                                .padding()
                                .foregroundColor(Color.white)
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
                        Spacer()
                    }
                    Spacer()
                }
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

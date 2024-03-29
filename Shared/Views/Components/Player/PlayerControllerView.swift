//
//  PlayerControllerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/20.
//

import CachedAsyncImage
import SwiftUI
struct PlayerControllerIconButtonView: View {
    @State var isHovered = false
    var action: () -> Void
    var active: Bool = false
    var fill: Bool = false
    var icon: String
    var body: some View {
        if active {
            Button(action: action) {
                Rectangle().fill(.white).frame(width: 48, height: 48)
                    .cornerRadius(12)
                    .mask(
                        ZStack {
                            Rectangle()
                            Image(systemName: icon + (fill ? ".fill" : ""))
                                .font(.system(size: 24))
                                .padding()
                                .foregroundColor(.black)
                                .blendMode(.destinationOut)
                        }
                    )
                    .onHover { hover in
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isHovered = hover
                        }
                    }
            }
            .hoverEffect()
        } else {
            Button(action: action) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .padding()
                    .foregroundColor(Color.white)
            }.buttonStyle(PlainButtonStyle())
                .frame(width: 48, height: 48)
                .background(isHovered ? Color.gray.opacity(0.25) : Color.gray.opacity(0))
                .cornerRadius(12)
                .contentShape(Rectangle())
                .onHover { hover in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isHovered = hover
                    }
                }
                .hoverEffect()
        }
    }
}

struct PlayerControllerView: View {
    @StateObject private var ppplayer = player
    @State var activeView = UIDevice.isIPhone ? "player" : "list"
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            if UIDevice.isIPhone {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 100, height: 4)
                    .cornerRadius(.infinity)
                    .opacity(0.75)
                    .padding(5.0)
            } else {
                HStack {
                    Spacer()
                    PlayerControllerIconButtonView(
                        action: { player.shuffle() },
                        icon: "shuffle"
                    )
                    PlayerControllerIconButtonView(
                        action: { dismiss() },
                        icon: "chevron.down"
                    )
                    Rectangle()
                        .frame(width: 5.0, height: 1.0)
                        .opacity(0)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height > 0 {
                                #if !targetEnvironment(macCatalyst)
                                    dismiss()
                                #endif
                            }
                        }
                )
            }
            HStack {
                if !UIDevice.isIPhone {
                    PlayerView()
                        .frame(width: 500.0)
                }
                if activeView == "player" {
                    PlayerView()
                }
                if activeView == "list" {
                    PlayerPlaylistView()
                }
                if activeView == "lyric" {
                    PlayerLyricView()
                }
            }.frame(maxWidth: 1200.0)
            // Spacer
            Spacer()
            HStack(spacing: 20) {
                Spacer()
                if UIDevice.isIPhone {
                    PlayerControllerIconButtonView(
                        action: { withAnimation(.easeInOut(duration: 0.1)) { activeView = "player" }},
                        active: activeView == "player",
                        fill: true,
                        icon: "play"
                    )
                }
                PlayerControllerIconButtonView(
                    action: { withAnimation(.easeInOut(duration: 0.1)) { activeView = "list" } },
                    active: activeView == "list",
                    icon: "list.bullet"
                )
                PlayerControllerIconButtonView(
                    action: { withAnimation(.easeInOut(duration: 0.1)) { activeView = "lyric" } },
                    active: activeView == "lyric",
                    fill: true,
                    icon: "captions.bubble"
                )
                Spacer()
            }
            Spacer()
        }

        .background(
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .ignoresSafeArea(.all)
                CachedAsyncImage(url: URL(string: PokaURLParser(player.currentPlayingItem!.song.cover))) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 50, opaque: true)
                        .id(player.currentPlayingItem!.song.cover)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .opacity(0.5)
            }
        )
        .preferredColorScheme(.dark)
    }
}

struct PlayerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControllerView()
    }
}

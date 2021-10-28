//
//  PlayerControllerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/20.
//

import SwiftUI
import CachedAsyncImage
struct PlayerControllerIconButtonView: View {
    var action: () -> Void
    var active: Bool = false
    var icon: String
    var body: some View{
        Button(action: action) {
            Image(systemName: icon + (active ? ".fill" : ""))
                .font(.system(size: 24))
                .padding()
                .foregroundColor(Color.white)
        }.buttonStyle(PlainButtonStyle())
            .frame(width: 56, height: 56)
            .background(active ? Color.white.opacity(0.05) : Color.clear)
            .cornerRadius(12)
    }
}
struct PlayerControllerView: View {
    @StateObject private var ppplayer = player
    @State var activeView = "player"
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        VStack{
            if UIDevice.isIPhone {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 100, height: 4)
                    .cornerRadius(.infinity)
                    .opacity(0.75)
                    .padding(5.0)
            } else {
                HStack{
                    Spacer()
                    PlayerControllerIconButtonView(
                        action: { presentationMode.wrappedValue.dismiss() },
                        active: false,
                        icon:  "xmark"
                    )
                }
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
            // Spacer
            Spacer()
            HStack(spacing: 20) {
                Spacer()
                
                PlayerControllerIconButtonView(
                    action: {activeView = "player" },
                    active: activeView == "player",
                    icon: "play"
                )
                PlayerControllerIconButtonView(
                    action: {activeView = "list"},
                    active: activeView == "list",
                    icon: "list.bullet.circle"
                )
                PlayerControllerIconButtonView(
                    action: {activeView = "lyric"},
                    active: activeView == "lyric",
                    icon:  "captions.bubble"
                )
                Spacer()
            }
            Spacer()
        }.background(
            ZStack{
                if #available(iOS 15.0, *) {
                    Rectangle()
                        .fill(Color.black)
                        .ignoresSafeArea()
                    CachedAsyncImage(url: URL(string: PokaURLParser(player.currentPlayingItem!.song.cover))){ image in
                        image
                            .resizable()
                            .blur(radius: 50, opaque: true)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    .ignoresSafeArea()
                    .opacity(0.5)
                }
                
            }
        )
    }
}

struct PlayerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControllerView()
    }
}

//
//  PlayerControllerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/20.
//

import SwiftUI

struct PlayerControllerView: View {
    @StateObject private var ppplayer = player
    @State var activeView = "player"
    var body: some View{
        VStack{
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
                
                Button(action: { activeView = "player" }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 24))
                        .padding()
                        .foregroundColor(Color.white)
                }.buttonStyle(PlainButtonStyle())
                    .frame(width: 56, height: 56)
                    .background(activeView == "player" ? Color.black.opacity(0.25) : Color.clear)
                    .cornerRadius(12)
                
                Button(action: { activeView = "list" }) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 24))
                        .padding()
                        .foregroundColor(Color.white)
                }.buttonStyle(PlainButtonStyle())
                    .frame(width: 56, height: 56)
                    .background(activeView == "list" ? Color.black.opacity(0.25) : Color.clear)
                    .cornerRadius(12)
                
                Button(action: { activeView = "lyric" }) {
                    Image(systemName: "captions.bubble.fill")
                        .font(.system(size: 24))
                        .padding()
                        .foregroundColor(Color.white)
                }.buttonStyle(PlainButtonStyle())
                    .frame(width: 56, height: 56)
                    .background(activeView == "lyric" ? Color.black.opacity(0.25) : Color.clear)
                    .cornerRadius(12)
                  
                
                Spacer()
            }
        }.background(
            ZStack{
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: baseURL + player.currentPlayingItem!.song.cover) ){ image in
                        image.resizable()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.black.opacity(0.7))
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity )
                    .blur(radius: 50, opaque: true)
                    .ignoresSafeArea()
                }
                
                Rectangle()
                    .fill(Color.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
            }
        )
    }
}

struct PlayerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControllerView()
    }
}

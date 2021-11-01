//
//  PlaylistItemView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/15.
//

import SwiftUI
import CachedAsyncImage

struct PlaylistCoverView: View {
    var coverURL: String
    var size: CGFloat = 40
    var baseURL = defaults.string(forKey: "baseURL") ?? ""
    var body: some View {
        CachedAsyncImage(url: URL(string: PokaURLParser(coverURL))){ image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .frame(width: size, height: size)
        .cornerRadius(5)
    }
}


struct PlaylistItemView: View {
    var playlist: Playlist
    
    var body: some View {
        NavigationLink(destination: PlaylistView(playlist: playlist)) {
            HStack{
                if playlist.image != nil {
                    PlaylistCoverView(coverURL: playlist.image ?? playlist.cover ?? "/img/icons/apple-touch-icon.png")
                } else {
                    Image(systemName: "music.note.list")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .frame(width: 40, height: 40)
                        .cornerRadius(5)
                }
                Text(playlist.name)
            }
        }
    }
}
struct VPlaylistItemView: View {
    var playlist: Playlist
    var body: some View {
        var imgLink: String? = playlist.image ?? playlist.cover ?? nil
        if imgLink != nil {
            if !imgLink!.hasPrefix("http") {
                imgLink = PokaURLParser(imgLink!)
            }
        }
        return NavigationLink(destination: PlaylistView(playlist: playlist)) {
            VStack(alignment: .leading){
                if #available(iOS 15.0, *), imgLink != nil {
                    CachedAsyncImage(url: URL(string: imgLink!)){ image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 140, height: 140)
                    .cornerRadius(5)
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                } else {
                    Image(systemName: "music.note.list")
                        .frame(width: 140, height: 140)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .aspectRatio(1, contentMode: .fill)
                        .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                }
                Text(playlist.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }
            .padding(.horizontal, 5.0)
        }.buttonStyle(PlainButtonStyle())
        
        
    }
}


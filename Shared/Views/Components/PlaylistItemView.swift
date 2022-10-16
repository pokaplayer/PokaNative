//
//  PlaylistItemView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/15.
//

import CachedAsyncImage
import SwiftUI

struct PlaylistCoverView: View {
    var coverURL: String
    var size: CGFloat = 40
    var baseURL = defaults.string(forKey: "baseURL") ?? ""
    var body: some View {
        CachedAsyncImage(url: URL(string: PokaURLParser(coverURL))) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .frame(width: size, height: size)
        .cornerRadius(8)
    }
}

struct PlaylistItemView: View {
    var playlist: Playlist

    var body: some View {
        NavigationLink(destination: PlaylistView(playlist: playlist)) {
            HStack {
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
    @State private var hovered = false
    var body: some View {
        var imgLink: String? = playlist.image ?? playlist.cover ?? nil
        if imgLink != nil {
            if !imgLink!.hasPrefix("http") {
                imgLink = PokaURLParser(imgLink!)
            }
        }
        return NavigationLink(destination: PlaylistView(playlist: playlist)) {
            VStack(alignment: .leading) {
                if imgLink != nil {
                    CachedAsyncImage(url: URL(string: imgLink!)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 140, height: 140)
                    .cornerRadius(hovered ? 20 : 10)
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(color: Color.black.opacity(hovered ? 0.4 : 0.2), radius: hovered ? 15.0 : 10, y: hovered ? 15 : 10)
                    .onHover { isHovered in
                        withAnimation {
                            hovered = isHovered
                        }
                        #if targetEnvironment(macCatalyst)
                            if isHovered {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        #endif
                    }
                } else {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 30))
                        .frame(width: 140, height: 140)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(hovered ? 20 : 10)
                        .aspectRatio(1, contentMode: .fit)
                        .shadow(color: Color.black.opacity(hovered ? 0.4 : 0.2), radius: hovered ? 15.0 : 10, y: hovered ? 15 : 10)
                        .onHover { isHovered in
                            withAnimation {
                                hovered = isHovered
                            }
                            #if targetEnvironment(macCatalyst)
                                if isHovered {
                                    NSCursor.pointingHand.push()
                                } else {
                                    NSCursor.pop()
                                }
                            #endif
                        }
                }
                Text(playlist.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text(NSLocalizedString(playlist.source, comment: ""))
                    .font(.caption)
                    .opacity(0.5)
            }
            .padding(.horizontal, 5.0)
        }.buttonStyle(PlainButtonStyle())
    }
}

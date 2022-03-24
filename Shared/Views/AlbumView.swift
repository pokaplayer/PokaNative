//
//  AlbumView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/7.
//

import CachedAsyncImage
import SwiftUI

struct AlbumView: View {
    var album: Album
    @State var loading = false
    @State var resData = [Song]()
    var baseURL = defaults.string(forKey: "baseURL") ?? ""

    var body: some View {
        List {
            VStack {
                CachedAsyncImage(url: URL(string: PokaURLParser(album.cover))) { image in
                    image.resizable()
                } placeholder: {
                    ZStack {
                        VStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.2))
                                .aspectRatio(1.0, contentMode: .fit)
                            Spacer()
                        }
                        ProgressView()
                    }
                }
                .frame(width: 200, height: 200)
                .cornerRadius(5)
                .aspectRatio(1, contentMode: .fill)
                .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)

                Text(album.name)
                    .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                Text(album.artist)
                    .font(.body)
                    .opacity(0.75)
                    .multilineTextAlignment(.center)
                HStack {
                    Spacer()
                }
            }
            .padding(.top, 10.0)
            if loading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                SongView(songs: resData)
            }
        }
        .navigationTitle("Album")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(album.name)
                        .fontWeight(.bold)
                    Text(album.artist)
                        .font(.caption)
                        .opacity(0.75)
                }
            }
        }.onAppear {
            self.loading = true
            PokaAPI.shared.getAlbumSongs(albumID: album.id, source: album.source) { result in
                self.resData = result.songs
                self.loading = false
            }
        }
        .padding(.bottom, player.currentPlayingItem != nil ? 56.0 : 0)
        .listStyle(GroupedListStyle())
        .frame(maxWidth: .infinity)
        // .navigationTitle("Album")
    }
}

/*
 struct AlbumView_Previews: PreviewProvider {
 static var previews: some View {

 }
 }*/

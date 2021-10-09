//
//  PlaylistsView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/9.
//

import SwiftUI
struct PlaylistCoverView: View {
    var coverURL: String
    var size: CGFloat = 40
    var baseURL = defaults.string(forKey: "baseURL") ?? ""
    var body: some View {
        AsyncImage(url: URL(string: coverURL.hasPrefix("http") ? coverURL : baseURL + coverURL)){ image in
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
                    PlaylistCoverView(coverURL: playlist.image ?? "/img/icons/apple-touch-icon.png")
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

struct PlaylistsView: View {
    
    var title: String?
    var playlist: [Playlist]?
    @State var resData: PlaylistReponse?
    var body: some View {
        
        VStack{
            if resData != nil || playlist != nil {
                List{
                    if resData != nil {
                        Section(header: Text("Playlists")) {
                            ForEach(resData?.playlists ?? [Playlist](), id: \.self) { item in
                                PlaylistItemView(playlist: item)
                            }
                        }
                        Section(header: Text("Folders")) {
                            ForEach(resData?.playlistFolders ?? [PlaylistFolder](), id: \.self) { item in
                                NavigationLink(destination: PlaylistsView(title: item.name, playlist: item.playlists)) {
                                    HStack{
                                        if item.image != nil {
                                            PlaylistCoverView(coverURL: item.image ?? "/img/icons/apple-touch-icon.png")
                                        } else {
                                            Image(systemName: "folder")
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(Color.green)
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(5)
                                        }
                                        Text(item.name)
                                    }
                                }
                            }
                        }
                    } else if playlist != nil{
                        ForEach(playlist ?? [Playlist](), id: \.self) { item in
                            PlaylistItemView(playlist: item)
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }.onAppear() {
            if playlist == nil {
                PokaAPI.shared.getPlaylists() { (result) in
                    self.resData = result
                }
            }
        }
        .navigationTitle(title ?? "Playlists")
    }
}
/*
 struct PlaylistsView_Previews: PreviewProvider {
 static var previews: some View {
 PlaylistsView()
 }
 }
 */

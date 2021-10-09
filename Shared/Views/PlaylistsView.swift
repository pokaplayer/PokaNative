//
//  PlaylistsView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/9.
//

import SwiftUI
struct PlaylistCoverView: View {
    var coverURL: String
    var baseURL = defaults.string(forKey: "baseURL") ?? "" 
    var body: some View {
        AsyncImage(url: URL(string: coverURL.hasPrefix("http") ? coverURL : baseURL + coverURL)){ image in
            image
                .resizable()
                .aspectRatio(1, contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 40, height: 40)
        .cornerRadius(5)
    }
}
struct PlaylistsView: View {
    
    var title: String?
    var playlist: Playlist?
    @State var resData: PlaylistReponse?
    var body: some View {
        
        VStack{
            List{
                Section(header: Text("Playlists")) {
                    ForEach(resData?.playlists ?? [Playlist](), id: \.self) { item in
                        NavigationLink(destination: FolderView()) {
                            HStack{
                                PlaylistCoverView(coverURL: item.image ?? "/img/icons/apple-touch-icon.png")
                                Text(item.name)
                            }
                        }
                    }
                }
                Section(header: Text("Folders")) {
                    ForEach(resData?.playlistFolders ?? [PlaylistFolder](), id: \.self) { item in
                        NavigationLink(destination: FolderView()) {
                            HStack{
                                PlaylistCoverView(coverURL: item.image ?? "/img/icons/apple-touch-icon.png")
                                Text(item.name)
                            }
                        }
                    }
                }
            }
        }.onAppear() {
            PokaAPI.shared.getPlaylists() { (result) in
                self.resData = result
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

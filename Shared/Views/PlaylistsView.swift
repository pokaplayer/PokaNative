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
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 40, height: 40)
        .cornerRadius(5)
        .aspectRatio(1, contentMode: .fill)
    }
}
struct PlaylistsView: View {
    
    var title: String?
    var playlist: Playlist?
    @State var resData = [Playlist]()
    var body: some View {
        
        VStack{
            List(resData){ item in
                HStack{
                      //  PlaylistCoverView(coverURL: item.image ?? "/img/icons/apple-touch-icon.png")
                        
                    Text(item.name)
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

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
    }
}

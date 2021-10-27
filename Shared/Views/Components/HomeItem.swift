//
//  HomeItem.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/14.
//

import SwiftUI

struct HomeItem: View {
    let item: HomeResponse
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(NSLocalizedString(item.title, comment: ""))
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
                Text(NSLocalizedString(item.source, comment: ""))
                    .font(.caption)
                    .opacity(0.5)
            }
            .padding(.horizontal, 10.0)
            if item.albums != nil && item.albums?.count ?? 0 > 0 {
                Text("Albums")
                    .padding(.horizontal, 10.0)
                    .opacity(0.5)
                    .font(.caption)
                ScrollView(.horizontal){
                    HStack(spacing: 10){
                        ForEach(item.albums!){ item in
                            AlbumItemView(item: item)
                                .frame(width: 150)
                        }
                    }
                    .padding(.horizontal, 10.0)
                }
            } 
            if item.playlists != nil && item.playlists?.count ?? 0 > 0 {
                Text("Playlists")
                    .padding(.horizontal, 10.0)
                    .opacity(0.5)
                    .font(.caption)
                ScrollView(.horizontal){
                    HStack(spacing: 10){
                        ForEach(item.playlists!){ item in
                            VPlaylistItemView(playlist: item)
                                .frame(width: 150)
                        }
                    }
                    .padding(.horizontal, 10.0)
                }
            }
        }
        .padding(.vertical, 5.0)
        
    }
}
/*
 struct HomeItem_Previews: PreviewProvider {
 static var previews: some View {
 HomeItem()
 }
 }
 */

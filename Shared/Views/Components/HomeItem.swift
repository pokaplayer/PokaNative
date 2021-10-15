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
        
        VStack{
            VStack(alignment: .leading){
                HStack{
                    Text(item.title)
                        .font(.title)
                    Spacer()
                    Text(item.source)
                        .font(.caption)
                }
                if item.albums != nil {
                    Text("Albums")
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            ForEach(item.albums!){ item in
                                AlbumItemView(item: item)
                                    .frame(width: 150)
                            }
                        }
                    }
                }
                if item.playlists != nil {
                    Text("Playlists")
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            ForEach(item.playlists!){ item in
                                VPlaylistItemView(playlist: item)
                                    .frame(width: 150)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10.0)
        }
    }
}
/*
 struct HomeItem_Previews: PreviewProvider {
 static var previews: some View {
 HomeItem()
 }
 }
 */

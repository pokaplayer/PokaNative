//
//  SongDetailView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/21.
//

import SwiftUI
import CachedAsyncImage

struct SongDetailView: View {
    var item: Song
    var body: some View {
        NavigationView {
            List {
                HStack{
                    CachedAsyncImage(url: URL(string:  baseURL + item.cover)){ image in
                        image.resizable()
                    } placeholder: {
                        ZStack{
                            Rectangle().opacity(0)
                            ProgressView()
                        }
                    }
                    .frame(width: 48, height: 48)
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.05), radius: 6.0, y: 6.0)
                    VStack(alignment: .leading){
                        Text(item.name)
                        Text(item.artist)
                            .font(.caption)
                            .opacity(0.75)
                    }
                }
                
                Section(header: Text("Actions")) {
                    Button(action: {
                        PPPlayer.shared.addSong(song: item)
                    }){
                        HStack{
                            Image(systemName: "plus")
                                .frame(width: 32, height: 32)
                            Text("Add this song to player")
                        }
                    }
                    Button(action: {}){
                        HStack{
                            Image(systemName: "plus")
                                .frame(width: 32, height: 32)
                            Text("Add to playlist")
                        }
                    }
                }
                Section(header: Text("Info")) {
                    NavigationLink(destination: AlbumsView(itemID: item.artistID ?? item.artist, source: item.source, name: item.artist, itemType: "artist")) {
                        HStack{
                            Image(systemName: "person")
                                .frame(width: 32, height: 32)
                            Text("Artist")
                            Spacer()
                            Text(item.artist).opacity(0.5)
                        }
                    }
                    if item.track != nil {
                        HStack{
                            Image(systemName: "list.number")
                                .frame(width: 32, height: 32)
                            Text("Track")
                            Spacer()
                            Text(String(item.track!)).opacity(0.5)
                        }
                    }
                    HStack{
                        Image(systemName: "opticaldisc")
                            .frame(width: 32, height: 32)
                        Text("Album")
                        Spacer()
                        Text(item.album).opacity(0.5)
                    }
                    HStack{
                        Image(systemName: "globe")
                            .frame(width: 32, height: 32)
                        Text("Source")
                        Spacer()
                        Text(item.source).opacity(0.5)
                    }
                    if item.codec != nil {
                        HStack{
                            Image(systemName: "doc")
                                .frame(width: 32, height: 32)
                            Text("Codec")
                            Spacer()
                            Text(item.codec!.uppercased()).opacity(0.5)
                        }
                    }
                    if item.bitrate != nil {
                        HStack{
                            Image(systemName: "radio")
                                .frame(width: 32, height: 32)
                            Text("Bitrate")
                            Spacer()
                            Text(String(item.bitrate! / 1000) + "K").opacity(0.5)
                        }
                    }
                    if item.year != nil {
                        HStack{
                            Image(systemName: "clock")
                                .frame(width: 32, height: 32)
                            Text("Year")
                            Spacer()
                            Text(String(item.year!)).opacity(0.5)
                        }
                    }
                }
            }.navigationTitle("Details")
        }
    }
}

/*
 struct SongDetailView_Previews: PreviewProvider {
 static var previews: some View {
 SongDetailView()
 }
 }
 */

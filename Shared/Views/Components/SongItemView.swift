//
//  SongItemView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/11/5.
//

import SwiftUI

struct SongItemView: View {
    var item: Song
    var items: [Song]
    var index: Int
    @State private var showSheet = false
    var body: some View {
        HStack {
            Button(action: {
                player.setSongs(songs: items)
                player.setTrack(index: index)
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .fontWeight(.bold)
                        Text(item.artist)
                            .font(.caption)
                            .opacity(0.75)
                    }
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            Button(action: {
                showSheet = true
            }) {
                Image(systemName: "info.circle")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5.0)
        .sheet(isPresented: $showSheet) {
            SongDetailView(item: item)
        }
    }
}

/*
 struct SongItemView_Previews: PreviewProvider {
     static var previews: some View {
         SongItemView()
     }
 }
 */

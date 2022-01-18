//
//  AlbumItemView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/14.
//

import SwiftUI

import CachedAsyncImage
struct AlbumItemView: View {
    let item: Album
    var body: some View {
        NavigationLink(destination: AlbumView(album: item)) {
            VStack(alignment: .leading) {
                if #available(iOS 15.0, *) {
                    CachedAsyncImage(url: URL(string: PokaURLParser(item.cover))) { image in
                        image.resizable()
                    } placeholder: {
                        ZStack {
                            VStack {
                                Rectangle()
                                    .fill(Color.black.opacity(0))
                                    .aspectRatio(1, contentMode: .fit)
                                    .cornerRadius(5)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                                Spacer()
                            }
                            ProgressView()
                        }
                    }.cornerRadius(5)
                        .aspectRatio(1, contentMode: .fit)
                        .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                }
                Text(item.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text(item.artist)
                    .font(.caption)
                    .lineLimit(1)
                    .opacity(0.5)
                HStack {
                    Spacer()
                }
            }
            .padding(.horizontal, 5.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/*
 struct AlbumItemView_Previews: PreviewProvider {
     static var previews: some View {
         AlbumItemView()
     }
 }*/

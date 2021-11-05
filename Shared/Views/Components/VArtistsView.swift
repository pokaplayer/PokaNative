//
//  VArtistsView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/11/5.
//

import SwiftUI
import CachedAsyncImage
struct VArtistsView: View {
    var item: Artist
    var body: some View {
        
        var imgLink: String? = item.cover
        if imgLink != nil {
            if !imgLink!.hasPrefix("http") {
                imgLink = PokaURLParser(imgLink!)
            }
        }
        return NavigationLink(destination: AlbumsView(itemID: item.id, source: item.source, name: item.name, itemType: "artist")) {
            VStack(alignment: .leading) {
                if imgLink != nil {
                    CachedAsyncImage(url: URL(string: imgLink!)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 140, height: 140)
                    .cornerRadius(5)
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                } else {
                    Image(systemName: "music.note.list")
                        .frame(width: 140, height: 140)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .aspectRatio(1, contentMode: .fill)
                        .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                }
                Text(item.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text(NSLocalizedString(item.source, comment: ""))
                    .font(.caption)
            }
            .padding(.horizontal, 5.0)
        }.buttonStyle(PlainButtonStyle())
    }
}
/*
struct VArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        VArtistsView()
    }
}
*/

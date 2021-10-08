//
//  AlbumsView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
struct AlbumsView: View { 
    var itemID, source, name, itemType: String?
    @State var resData = [Album]()
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    private var baseURL = defaults.string(forKey: "baseURL") ?? ""
    var body: some View {
        HStack{
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(resData, id: \.self) { item in
                        NavigationLink(destination: AlbumView(album: item)) {
                            VStack(alignment: .leading){
                                if #available(iOS 15.0, *) {
                                    AsyncImage(url: URL(string: baseURL + item.cover)){ image in
                                        image
                                            .resizable()
                                    } placeholder: {
                                        ZStack{
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
                                        .aspectRatio(1, contentMode: .fill)
                                        .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                                }
                                Text(item.name)
                                    .font(.body)
                                    .lineLimit(1)
                                Text(item.artist)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .foregroundColor(Color.black.opacity(0.75))
                                HStack{
                                    Spacer()
                                }
                            }
                            .padding(10)
                            
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
        }
        .frame(width: .infinity)
        .onAppear() {
            PokaAPI.shared.getAlbums(itemID: itemID, source: source, itemType: itemType) { (result) in
                self.resData = result.albums
            } 
        }
        .navigationTitle(name ?? "Albums")
    }
}



/*struct AlbumsView_Previews: PreviewProvider {
 static var previews: some View {
 AlbumsView()
 }
 }*/

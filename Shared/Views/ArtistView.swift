//
//  ArtistView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import CachedAsyncImage
import SwiftUI

var baseURL = defaults.string(forKey: "baseURL") ?? ""
struct ArtistView: View {
    @State var resData: [Artist]?
    @State var filteredData: [Artist]?
    @State private var searchText = ""
    var body: some View {
        VStack{
            if filteredData != nil {
                List(filteredData!) { item in
                    NavigationLink(destination: AlbumsView(itemID: item.id, source: item.source, name: item.name, itemType: "artist")) {
                        HStack {
                            CachedAsyncImage(url: URL(string: PokaURLParser(item.cover))) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .cornerRadius(.infinity)
                            .aspectRatio(1, contentMode: .fill)
                            Text(item.name)
                        }
                    }
                }
                .padding(.bottom, player.currentPlayingItem != nil && UIDevice.isIPhone ? 56.0 : 0)
                .navigationTitle("Artists")
                .searchable(text: $searchText)
                .onChange(of: searchText) { searchText in
                    if !searchText.isEmpty {
                        filteredData = resData!.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                    } else {
                        filteredData = resData
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            PokaAPI.shared.getArtist { result in
                self.resData = result.artists
                self.filteredData = result.artists
            }
        }
        
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView()
    }
}

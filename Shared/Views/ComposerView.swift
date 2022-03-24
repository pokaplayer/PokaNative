//
//  ComposerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import CachedAsyncImage
import SwiftUI

struct ComposerView: View {
    var baseURL = defaults.string(forKey: "baseURL") ?? ""
    @State var resData: [Composer]?
    @State var filteredData: [Composer]?
    @State private var searchText = ""
    var body: some View {
        List(filteredData ?? [Composer]()) { item in
            NavigationLink(destination: AlbumsView(itemID: item.id, source: item.source, name: item.name, itemType: "composer")) {
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
        .padding(.bottom, player.currentPlayingItem != nil ? 56.0 : 0)
        .onAppear {
            PokaAPI.shared.getComposers { result in
                self.resData = result.composers
                self.filteredData = result.composers
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { searchText in
            if !searchText.isEmpty {
                filteredData = resData!.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            } else {
                filteredData = resData
            }
        }
        .navigationTitle("Composers")
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView()
    }
}

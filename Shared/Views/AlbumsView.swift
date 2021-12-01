//
//  AlbumsView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
struct AlbumsView: View {
    var itemID, source, name, itemType: String?
    init(itemID: String, source: String, name: String, itemType: String) {
        self.itemID = itemID
        self.source = source
        self.name = name
        self.itemType = itemType
    }

    init() {}

    @State var resData = [Album]()
    private var gridItemLayout = [GridItem(.adaptive(minimum: 150))]
    private var baseURL = defaults.string(forKey: "baseURL") ?? ""
    var body: some View {
        HStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 10) {
                    ForEach(resData, id: \.self) { item in
                        AlbumItemView(item: item)
                    }
                }
                .padding(.horizontal, 10)

                if player.currentPlayingItem != nil && UIDevice.isIPhone {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 56)
                }
            }
        }
        .frame(width: .infinity)
        .onAppear {
            PokaAPI.shared.getAlbums(itemID: itemID, source: source, itemType: itemType) { result in
                self.resData = result.albums
            }
        }
        .navigationTitle(name ?? NSLocalizedString("Albums", comment: ""))
    }
}

/* struct AlbumsView_Previews: PreviewProvider {
 static var previews: some View {
 AlbumsView()
 }
 } */

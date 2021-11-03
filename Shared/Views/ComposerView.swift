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
    @State var resData: Composers?
    var body: some View {
        List(resData?.composers ?? [Composer]()) { item in
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
        .onAppear {
            PokaAPI.shared.getComposers { result in
                self.resData = result
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

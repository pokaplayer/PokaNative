//
//  ArtistView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import SwiftUI

var baseURL = defaults.string(forKey: "baseURL") ?? ""
struct ArtistView: View {
    @State var resData: Artists?
    var body: some View {
        List(resData?.artists ?? [Artist]()){ item in 
            NavigationLink(destination: AlbumsView(itemID: item.id, source: item.source, name: item.name, itemType: "artist")) {
                HStack{
                    AsyncImage(url: URL(string: baseURL + item.cover) ){ image in
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
        .onAppear() {
            PokaAPI.shared.getArtist() { (result) in
                self.resData = result
            }
        }
        .navigationTitle("Artists")
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView()
    }
}

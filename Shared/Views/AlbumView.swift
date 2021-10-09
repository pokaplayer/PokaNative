//
//  AlbumView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/7.
//

import SwiftUI

struct AlbumView: View {
    var album: Album
    @State var resData = [Song]()
    var baseURL = defaults.string(forKey: "baseURL") ?? ""
    
    var body: some View {
        
        List{
            VStack{
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: baseURL + album.cover) ){ image in
                        image.resizable()
                    } placeholder: {
                        ZStack{
                            VStack {
                                Rectangle()
                                    .fill(Color.black.opacity(0.2))
                                    .aspectRatio(1.0, contentMode: .fit)
                                Spacer()
                            }
                            ProgressView()
                        }
                    }
                    .frame(width: 200, height: 200)
                    .cornerRadius(5)
                    .aspectRatio(1, contentMode: .fill)
                    .shadow(color: Color.black.opacity(0.2), radius: 10.0, y: 10.0)
                }
                Text(album.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text(album.artist)
                    .font(.caption)
                    .foregroundColor(Color.black.opacity(0.75))
                    .multilineTextAlignment(.center)
                HStack  {
                    Spacer()
                }
            }
            .listRowSeparator(.hidden) 
            .padding(.top, 10.0)
            ForEach(resData){item in
                VStack(alignment: .leading){
                    Text(item.name)
                    Text(item.artist)
                        .font(.caption)
                        .foregroundColor(Color.black.opacity(0.75))
                }
                
            }
        }
        /*.toolbar {
         ToolbarItem(placement: .principal) {
         VStack {
         Text(album.name)
         Text(album.artist)
         .font(.caption)
         .foregroundColor(Color.black.opacity(0.75))
         }
         }
         }*/.onAppear() {
             PokaAPI.shared.getAlbumSongs(albumID: album.id, source: album.source) { (result) in
                 self.resData = result.songs
                 print(result.songs)
             }
         }
        
         .frame(maxWidth: .infinity)
         .navigationTitle("Album")
    }
}
/*
 struct AlbumView_Previews: PreviewProvider {
 static var previews: some View {
 
 }
 }*/

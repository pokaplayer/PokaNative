//
//  HomeRandomPlay.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/27.
//

import SwiftUI

struct HomeRandomPlay: View {
    @State private var items: [Song]?
    var body: some View {
        VStack(alignment: .leading){
            Text("Shuffle")
                .font(.body)
                .fontWeight(.bold)
            Text("Click the button below to randomly play the songs in the library")
                .opacity(0.5)
                .font(.caption)
            Button(action: {
                if items != nil {
                    player.setSongs(songs: items!)
                    player.setTrack(index: 0)
                }
            }){
                HStack{
                    Image(systemName: "play")
                    Text("Play")
                        .font(.caption)
                }
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.purple, lineWidth: 1)
            )
            HStack{
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .onAppear(perform: {
            PokaAPI.shared.getRandomSongs() { result in
                self.items = result
            }
        })
    }
}
struct HomeRandomPlay_Previews: PreviewProvider {
    static var previews: some View {
        HomeRandomPlay()
    }
}

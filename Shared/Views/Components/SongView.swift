//
//  SongView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/9.
//

import SwiftUI

struct SongView: View {
    var song: Song
    var body: some View {
        
        VStack(alignment: .leading){
            Text(song.name)
            Text(song.artist)
                .font(.caption)
                .foregroundColor(Color.black.opacity(0.75))
        }
            
    }
}
 

//
//  PlayerLyricView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/19.
//

import SwiftUI

struct PlayerLyricView: View {
    var body: some View {
        VStack{
            ScrollView{
                HStack{
                    Spacer()
                }
                
                Text("TBD").font(.title).foregroundColor(Color.white)
            }
            Spacer()
        }
    }
}

struct PlayerLyricView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLyricView()
    }
}

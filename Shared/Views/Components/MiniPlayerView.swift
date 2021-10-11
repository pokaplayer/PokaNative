//
//  MiniPlayerView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/10.
//

import SwiftUI

struct MiniPlayerView: View {
    var tabBarHeight: CGFloat
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Rectangle()
                    .background(.ultraThinMaterial)
                    .frame(width: 55, height: 55)
                    .cornerRadius(8.0)
                Text("Name of really cool song")
                Spacer()
                Image(systemName: "play.circle")
                    .font(.title)
            }
            .padding(.horizontal)
            Spacer()
        }
        .background(.thickMaterial)
        .frame(height: tabBarHeight)
        .offset(y: -tabBarHeight)
    }
}
 

//
//  Home.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI

struct Home: View {
    @State var resData: [HomeResponse]?
    var body: some View {
        ScrollView {
            HomeRandomPlay()
                .padding(5)
            if resData != nil {
                ForEach(resData!) { item in

                    Divider()
                    HomeItem(item: item)
                        .padding(5)
                }
            } else {
                ProgressView()
            }
            Spacer()
            Rectangle()
                .fill(.clear)
                .frame(height: 56)
        }
        .navigationTitle("Home")
        .onAppear {
            if resData == nil {
                PokaAPI.shared.getHome { result in
                    self.resData = result
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

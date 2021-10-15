//
//  Home.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI

struct Home: View {
    @State var resData = [HomeResponse]()
    var body: some View {
        
        NavigationView {
            ScrollView{
                ForEach(resData) { item in
                    HomeItem(item: item)
                        .background(.ultraThinMaterial)
                        .cornerRadius(5)
                        .padding(5)
                }
                Spacer()
            }
            .navigationTitle("Home")
            .onAppear() {
                PokaAPI.shared.getHome() { (result) in
                    self.resData = result
                }
            }
            .background(
                AsyncImage(url: URL(string: "https://i.loli.net/2021/07/12/G3cLQpYIqfXF8mo.jpg"))
                    .ignoresSafeArea(.all)
                    .mask(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .top, endPoint: .bottom))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

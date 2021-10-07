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
        VStack{
            Text("Home")
            /*List(resData){ homeItem in
                
                Text(homeItem.title)
                
            }.onAppear() {
                PokaAPI.shared.getHome() { (result) in
                    self.resData = result
                }
            }*/
            
            
        }.navigationTitle("Home")
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

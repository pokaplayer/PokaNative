//
//  SettingAboutView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/12.
//

import SwiftUI

struct SettingAboutView: View {
    var version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    var body: some View {
        List{
            VStack{ 
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128.0, height: 128.0)
                Text("PoakPlayer")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("✨Native✨")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .opacity(0.75)
                HStack{
                    Spacer()
                }
            }
            HStack{
                Image(systemName: "info.circle")
                Text("App version")
                Spacer()
                Text(version).opacity(0.5)
            }
            
            Link(destination: URL(string: "https://github.com/pokaplayer/PokaNative")!){
                HStack{
                    Image(systemName: "globe.asia.australia")
                    Text("GitHub")
                    Spacer()
                }
            }
            
            Link(destination: URL(string: "https://github.com/pokaplayer/PokaNative/graphs/contributors")!){
                HStack{
                    Image(systemName: "person")
                    Text("Contributors")
                    Spacer()
                }
            }
        }
            .navigationTitle("About")
    }
}

struct SettingAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingAboutView()
    }
}

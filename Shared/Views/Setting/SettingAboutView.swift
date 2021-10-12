//
//  SettingAboutView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/12.
//

import SwiftUI

struct SettingAboutView: View {
    var version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    @State private var showAlert: Bool = false
    @State private var versionClickTimes: Int = 0
    var body: some View {
        List{
            VStack{
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64.0, height: 64.0)
                    .padding(.top, 5.0)
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
            Button(action: {
                versionClickTimes += 1
                if versionClickTimes >= 7 {
                    versionClickTimes = 0
                    showAlert = true
                }
            }){
                HStack{
                    Image(systemName: "info.circle")
                    Text("App version")
                    Spacer()
                    Text(version).opacity(0.5)
                }
            }.buttonStyle(PlainButtonStyle())
            
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
        .alert("點那麼多次是要命ㄛ",isPresented: $showAlert)  {
            Button("：（", role: .cancel) { }
        }
    }
}

struct SettingAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingAboutView()
    }
}

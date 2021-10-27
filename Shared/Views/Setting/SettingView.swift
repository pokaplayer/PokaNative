//
//  SettingView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/12.
//

import SwiftUI

struct SettingView: View {
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About")){
                    NavigationLink(destination: SettingAboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                    
                }
                Section(header: Text("Settings")){
                    NavigationLink(destination: SettingAudioQualityView()) {
                        Label("Audio quality", systemImage: "headphones")
                    }
                    
                } 
            }.navigationTitle("Settings")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

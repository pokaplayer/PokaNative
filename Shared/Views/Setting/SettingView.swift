//
//  SettingView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/12.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            Section(header: Text("About")) {
                NavigationLink(destination: SettingAboutView()) {
                    Label("About", systemImage: "info.circle")
                }
            }
            Section(header: Text("Settings")) {
                NavigationLink(destination: SettingAudioQualityView()) {
                    Label("Audio quality", systemImage: "headphones")
                }
                NavigationLink(destination: SettingDataRecording()) {
                    Label("Data record", systemImage: "arrow.up.doc")
                }
                NavigationLink(destination: SettingUser()) {
                    Label("User", systemImage: "person")
                }
            }
        }.navigationTitle("Settings")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

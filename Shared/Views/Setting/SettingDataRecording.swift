//
//  SettingDataRecording.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/11/1.
//

import SwiftUI

struct SettingDataRecording: View {
    @AppStorage("dataRecording") var dataRecordingEnadled = false
    var body: some View {
        List {
            Section(footer: Text("The data will only be calculated on your server and will not be uploaded to the Internet. The feature can provide you with a better experience (like: annual review, recent play). You can turn off this feature and clear the recorded data if you want.")) {
                Toggle("Record playback data", isOn: $dataRecordingEnadled)
                /*
                 Button(action: {}) {
                 VStack {
                 Text("Clear the recorded data")
                 Text("\(123) records have been recorded")
                 .font(.caption)
                 .opacity(0.5)
                 }
                 }
                 .buttonStyle(PlainButtonStyle())
                 */
            }
        }
        .navigationTitle("Data record")
    }
}

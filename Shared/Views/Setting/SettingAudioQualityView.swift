//
//  AudioQualityView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/13.
//

import SwiftUI
struct CheckMarkView: View {
    let isChecked: Bool
    var body: some View {
        if isChecked {
            Image(systemName: "checkmark")
                .padding()
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
        } else {
            Image(systemName: "square")
                .padding()
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)
                .opacity(0)
        }
    }
}

struct SettingAudioQualityView: View {
    @State var audioQuality: String = defaults.string(forKey: "audioQuality") ?? "high"
    var body: some View {
        List {
            Section(footer: Text("The audio quality setting will not work for songs that are currently in the queue")) {
                Button(action: {
                    setAudioQuality("low")
                }) {
                    HStack {
                        CheckMarkView(isChecked: audioQuality == "low")
                        VStack(alignment: .leading) {
                            Text("Low")
                            Text("Only use when the internet is slow")
                                .font(.caption)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())

                Button(action: {
                    setAudioQuality("medium")
                }) {
                    HStack {
                        CheckMarkView(isChecked: audioQuality == "medium")
                        VStack(alignment: .leading) {
                            Text("Medium")
                            Text("Able to stream smoothly under 3G network")
                                .font(.caption)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())

                Button(action: {
                    setAudioQuality("high")
                }) {
                    HStack {
                        CheckMarkView(isChecked: audioQuality == "high")
                        VStack(alignment: .leading) {
                            Text("High")
                            Text("Able to stream smoothly under 4G/LTE network")
                                .font(.caption)
                        }
                    }

                }.buttonStyle(PlainButtonStyle())

                Button(action: {
                    setAudioQuality("original")
                }) {
                    HStack {
                        CheckMarkView(isChecked: audioQuality == "original")
                        VStack(alignment: .leading) {
                            Text("Original")
                            Text("Uncompressed audio, only use when the internet is fast")
                                .font(.caption)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())
            }
        }.navigationTitle("Audio quality")
    }

    func setAudioQuality(_ q: String) {
        audioQuality = q
        defaults.set(q, forKey: "audioQuality")
    }
}

struct SettingAudioQualityView_Previews: PreviewProvider {
    static var previews: some View {
        SettingAudioQualityView()
    }
}

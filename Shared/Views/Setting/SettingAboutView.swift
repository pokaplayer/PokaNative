//
//  SettingAboutView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/12.
//

import SwiftUI

struct SettingAboutView: View {
    var version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    @State private var serverStatus: StatusReponse?
    @State private var showAlert: Bool = false
    @State private var versionClickTimes: Int = 0
    var body: some View {
        List {
            VStack {
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
                HStack {
                    Spacer()
                }
            }
            Section(header: Text("App Info")) {
                Button(action: {
                    versionClickTimes += 1
                    if versionClickTimes >= 7 {
                        versionClickTimes = 0
                        showAlert = true
                    }
                }) {
                    HStack {
                        Text("App version")
                        Spacer()
                        Text(version).opacity(0.5)
                    }
                }.buttonStyle(PlainButtonStyle())
            }
            if serverStatus != nil {
                Section(header: Text("Server Status")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("User ID")
                            Spacer()
                        }
                        Text(serverStatus!.uid)
                            .opacity(0.5)
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                    }
                    HStack {
                        Text("Server version")
                        Spacer()
                        Text(serverStatus!.version).opacity(0.5)
                    }
                    if serverStatus!.debug {
                        HStack {
                            Text("Commit")
                            Spacer()
                            Text(serverStatus!.debugString ?? "None").opacity(0.5)
                        }
                    }
                }
            }
            Section(header: Text("Links")) {
                Link(destination: URL(string: "https://github.com/pokaplayer/PokaNative")!) {
                    HStack {
                        Text("GitHub")
                        Spacer()
                        Image(systemName: "arrow.up.right.square.fill")
                    }
                }

                Link(destination: URL(string: "https://github.com/pokaplayer/PokaNative/graphs/contributors")!) {
                    HStack {
                        Text("Contributors")
                        Spacer()
                        Image(systemName: "arrow.up.right.square.fill")
                    }
                }
            }
        }
        .navigationTitle("About")
        .alert("點那麼多次是要命ㄛ", isPresented: $showAlert) {
            Button("：（", role: .cancel) {}
        }
        .onAppear {
            PokaAPI.shared.getStatus { result in
                self.serverStatus = result
            }
        }
    }
}

struct SettingAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingAboutView()
    }
}

//
//  ContentView.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
struct ContentView: View {
    @StateObject private var ppplayer = player
    @State private var selectName: String? = "Home"
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List {
                    Group {
                        NavigationLink(destination: Home(), tag: "Home", selection: $selectName) {
                            Label("Home", systemImage: "house")
                        }
                        NavigationLink(destination: SearchView(), tag: "Search", selection: $selectName) {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    }

                    Group {
                        Text("Library")
                            .foregroundColor(.gray)
                        NavigationLink(destination: AlbumsView(), tag: "Albums", selection: $selectName) {
                            Label("Albums", systemImage: "opticaldisc")
                        }
                        NavigationLink(destination: FolderView(), tag: "Folders", selection: $selectName) {
                            Label("Folders", systemImage: "folder")
                        }
                        NavigationLink(destination: ArtistView(), tag: "Artists", selection: $selectName) {
                            Label("Artists", systemImage: "music.mic")
                        }
                        NavigationLink(destination: ComposerView(), tag: "Composers", selection: $selectName) {
                            Label("Composers", systemImage: "pencil")
                        }
                        NavigationLink(destination: PlaylistsView(), tag: "Playlists", selection: $selectName) {
                            Label("Playlists", systemImage: "music.note.list")
                        }
                    }

                    Group {
                        Text("Settings")
                            .foregroundColor(.gray)
                        NavigationLink(destination: SettingView(), tag: "Settings", selection: $selectName) {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                }.listStyle(.sidebar)
                    .background(Color.black.opacity(0.05))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
        .safeAreaInset(edge: .bottom, spacing: 72) {
            MiniPlayerView()
                .frame(height: 64, alignment: .bottomLeading)
                .background(.regularMaterial)
                .ignoresSafeArea(.all)
        }
        .background(.clear)
        .withHostingWindow { window in
            #if targetEnvironment(macCatalyst)
                if let titlebar = window?.windowScene?.titlebar {
                    titlebar.titleVisibility = .hidden
                    titlebar.toolbar = nil
                }

                UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                    windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1000, height: 800)
                }
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        background(HostingWindowFinder(callback: callback))
    }
}

private struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> Void

    func makeUIView(context _: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}

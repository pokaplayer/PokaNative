//
//  ContentView.swift
//  Shared
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI
struct ContentView: View {
    @StateObject private var ppplayer = player
    @State var showFullScreenPlayer = false
    @State private var selectName: String? = "Home"
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List {
                    Group {
                        NavigationLink(destination: Home(), tag: "Home", selection: $selectName) {
                            Label("Home", systemImage: "house")
                        }
                        .padding(5.0)
                        NavigationLink(destination: SearchView(), tag: "Search", selection: $selectName) {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .padding(5.0)
                    }

                    Group {
                        Text("Library")
                            .foregroundColor(.gray)
                        NavigationLink(destination: AlbumsView(), tag: "Albums", selection: $selectName) {
                            Label("Albums", systemImage: "opticaldisc")
                        }
                        .padding(5.0)
                        NavigationLink(destination: FolderView(), tag: "Folders", selection: $selectName) {
                            Label("Folders", systemImage: "folder")
                        }
                        .padding(5.0)
                        NavigationLink(destination: ArtistView(), tag: "Artists", selection: $selectName) {
                            Label("Artists", systemImage: "music.mic")
                        }
                        .padding(5.0)
                        NavigationLink(destination: ComposerView(), tag: "Composers", selection: $selectName) {
                            Label("Composers", systemImage: "pencil")
                        }
                        .padding(5.0)
                        NavigationLink(destination: PlaylistsView(), tag: "Playlists", selection: $selectName) {
                            Label("Playlists", systemImage: "music.note.list")
                        }
                        .padding(5.0)
                    }

                    Group {
                        Text("Settings")
                            .foregroundColor(.gray)
                        NavigationLink(destination: SettingView(), tag: "Settings", selection: $selectName) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .padding(5.0)
                    }
                }.listStyle(.sidebar)
                    .background(Color.black.opacity(0.05))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
        .safeAreaInset(edge: .bottom, spacing: 72) {
            MiniPlayerView()
                .frame(height: 72, alignment: .bottomLeading)
                .onTapGesture {
                    showFullScreenPlayer = true
                }
                .background(.regularMaterial)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded { value in
                            if abs(value.translation.width) > abs(value.translation.height) {
                                if value.translation.width < 0 {
                                    player.nextTrack()
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                }
                                if value.translation.width > 0 {
                                    player.previousTrack()
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                }
                            } else {
                                if value.translation.height < 0 {
                                    showFullScreenPlayer = true
                                }

                                if value.translation.height > 0 {
                                    // down
                                }
                            }
                        }
                )
                .ignoresSafeArea(.all)
        }
        .background(.clear)
        .fullScreenCover(isPresented: $showFullScreenPlayer, content: PlayerControllerView.init)
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

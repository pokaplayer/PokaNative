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
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List {
                    NavigationLink(destination: Home()) {
                        Label("Home", systemImage: "house")
                    }
                    .padding(5.0)
                    NavigationLink(destination: SearchView()) {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .padding(5.0)
                    NavigationLink(destination: AlbumsView()) {
                        Label("Albums", systemImage: "opticaldisc")
                    }
                    .padding(5.0)
                    NavigationLink(destination: FolderView()) {
                        Label("Folders", systemImage: "folder")
                    }
                    .padding(5.0)
                    NavigationLink(destination: ArtistView()) {
                        Label("Artists", systemImage: "music.mic")
                    }
                    .padding(5.0)
                    NavigationLink(destination: ComposerView()) {
                        Label("Composers", systemImage: "pencil")
                    }
                    .padding(5.0)
                    NavigationLink(destination: PlaylistsView()) {
                        Label("Playlists", systemImage: "music.note.list")
                    }
                    .padding(5.0)
                    NavigationLink(destination: SettingView()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .padding(5.0)
                }
            }.navigationTitle("PokaPlayer")
            Home()
        }
        .preferredColorScheme(.light)
        .padding(.bottom, player.currentPlayingItem != nil ? 72.0 : 0)
        .fullScreenCover(isPresented: $showFullScreenPlayer, content: PlayerControllerView.init)
        .overlay(
            alignment: .bottom,
            content: {
                MiniPlayerView()
                    .frame(height: 72)
                    .onTapGesture {
                        showFullScreenPlayer = true
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                                if value.translation.width < 0 {
                                    // left
                                }
                                
                                if value.translation.width > 0 {
                                    // right
                                }
                                if value.translation.height < 0 {
                                    showFullScreenPlayer = true
                                }
                                
                                if value.translation.height > 0 {
                                    // down
                                }
                            })
                    )
            }
        )
        .withHostingWindow { window in
#if targetEnvironment(macCatalyst)
            if let titlebar = window?.windowScene?.titlebar {
                titlebar.titleVisibility = .hidden
                titlebar.toolbar = nil
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


extension View {
    fileprivate func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

fileprivate struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

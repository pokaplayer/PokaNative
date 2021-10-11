//
//  ContentViewiOS.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/7.
//

import SwiftUI
struct TabBarAccessor: UIViewControllerRepresentable {
    var callback: (UITabBar) -> Void
    private let proxyController = ViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
    UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }
    
    typealias UIViewControllerType = UIViewController
    
    private class ViewController: UIViewController {
        var callback: (UITabBar) -> Void = { _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar.tabBar)
            }
        }
    }
}
struct ContentViewiOS: View {
    @State private var tabBarHeight: CGFloat = .zero
    var body: some View {
        VStack {
            TabView{
                Home()
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }.background(
                        TabBarAccessor { tabBar in
                            tabBarHeight = tabBar.bounds.height 
                        }
                    )
                Library()
                    .tabItem{
                        Label("Library", systemImage: "rectangle.stack")
                    }
                PlayerView()
                    .tabItem{
                        Label("Player", systemImage: "music.note")
                    }
                Text("Search")
                    .tabItem{
                        Label("Search", systemImage: "magnifyingglass")
                    }
                Text("Setting")
                    .tabItem{
                        Label("Setting", systemImage: "gearshape")
                    }
            }
            //.overlay(MiniPlayerView(tabBarHeight: tabBarHeight), alignment: .bottom)
        }
    }
}

struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}

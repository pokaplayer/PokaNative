//
//  FolderView.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/8.
//

import SwiftUI

struct FolderView: View {
    var folderID, source, title: String?
    @State var resData: Folders?
    var body: some View {
        VStack {
            List {
                if resData?.folders != nil && !(resData?.folders.isEmpty ?? false) {
                    Section(header: Text("Folders")) {
                        ForEach(resData?.folders ?? [Folder](), id: \.self) { item in
                            NavigationLink(destination: FolderView(folderID: item.id, source: item.source, title: item.name)) {
                                Text(item.name)
                            }
                        }
                    }
                }
                if resData?.songs != nil && !(resData?.songs.isEmpty ?? false) {
                    Section(header: Text("Songs")) {
                        SongView(songs: resData?.songs ?? [Song]())
                    }
                }
            }
        }.onAppear {
            PokaAPI.shared.getFolder(folderID: folderID, source: source) { result in
                self.resData = result
            }
        }
        .navigationTitle(title ?? NSLocalizedString("Folders", comment: ""))
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView()
    }
}

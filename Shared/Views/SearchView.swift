//
//  SearchView.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/28.
//

import SwiftUI
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SearchView: View {
    @State var searchText: String = ""
    @State var searching = false
    @State var loading = false
    @State var resData: SearchReponse?
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.systemGray6)
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField(NSLocalizedString("Search ...", comment: ""), text: $searchText)
                            { startedEditing in
                                if startedEditing {
                                    withAnimation {
                                        searching = true
                                    }
                                }
                            } onCommit: {
                                withAnimation {
                                    searching = false
                                    UIApplication.shared.dismissKeyboard()
                                    getSearchResult()
                                }
                            }
                            .foregroundColor(.label)
                            .submitLabel(.go)
                    }
                    .foregroundColor(.gray)
                    .padding(.leading, 13)
                }
                .frame(height: 40)
                .cornerRadius(13)
                .padding()
                if searching {
                    Button(action: {
                        UIApplication.shared.dismissKeyboard()
                        getSearchResult()
                    }) {
                        Text("Search")
                    }
                    .padding(.trailing, 10.0)
                }
            }
            if loading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if resData != nil {
                ScrollView {
                    SearchResultView(items: resData!)
                }
            }
            Spacer()

            if player.currentPlayingItem != nil {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 72)
            }
        }
        .navigationTitle("Search")
        .toolbar {
            if searching {
                Button(NSLocalizedString("Cancel", comment: "")) {
                    searchText = ""
                    withAnimation {
                        UIApplication.shared.dismissKeyboard()
                        searching = false
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width < 0 {
                        // left
                    }
                    if value.translation.width > 0 {
                        // right
                    }
                    if value.translation.height < 0 {
                        searching = false
                        UIApplication.shared.dismissKeyboard()
                    }
                    if value.translation.height > 0 {
                        searching = false
                        UIApplication.shared.dismissKeyboard()
                    }
                }
        )
    }

    func getSearchResult() {
        resData = nil
        loading = true
        PokaAPI.shared.getSearchResult(keyword: searchText) { result in
            self.resData = result
            self.loading = false
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

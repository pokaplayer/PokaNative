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
    @State var resData: SearchReponse?
    var body: some View {
        VStack(alignment: .leading){
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
                            }
                        } .foregroundColor(.label)
                    }
                    .foregroundColor(.gray)
                    .padding(.leading, 13)
                }
                .frame(height: 40)
                .cornerRadius(13)
                .padding()
                Spacer()
                if searching {
                    Button(action: {
                        UIApplication.shared.dismissKeyboard() 
                        getSearchResult()
                    }){
                        Text("Search")
                    }
                    .padding(.trailing, 10.0)
                }
            }
            if resData != nil {
                ScrollView{
                    SearchResultView(items: resData!)
                }
            }
            Spacer()
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
                .onChanged({ value in
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
                })
        )
        
    }
    func getSearchResult(){
        PokaAPI.shared.getSearchResult(keyword: self.searchText){ (result) in
            self.resData = result
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

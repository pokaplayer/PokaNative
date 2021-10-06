//
//  Login.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI

struct Login: View {
    @State var server: String = ""
    @State var username: String = ""
    @State var password: String = ""
    
    @Binding var showLogin: Bool
    var body: some View {
        VStack {
            Label("Your account", systemImage: "person")
                .font(.title)
                .labelStyle(IconOnlyLabelStyle())
            Text("Login")
                .font(.title)
                .fontWeight(.light)
                .padding(.bottom, 20)
            
            TextField("Server", text: $server)
                .cornerRadius(5.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Username", text: $username)
                .cornerRadius(5.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .cornerRadius(5.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {PokaAPI.shared.login( server: server,  username: username,  password: password) { result in
                switch result {
                case .success(let LoginResponse):
                    print(LoginResponse)
                    showLogin = false
                case .failure(let LoginResponse):
                    print(LoginResponse)
                }
            }}, label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            })
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Button("Close") {
                showLogin.toggle()
            }
            
        }
        .padding(20.0)
        .frame(width: 300.0)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(showLogin: .constant(true))
    }
}

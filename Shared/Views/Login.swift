//
//  Login.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI

struct Login: View {
    @State var server: String = defaults.string(forKey: "baseURL") ?? ""
    @State var username: String = defaults.string(forKey: "username") ?? ""
    @State var password: String = defaults.string(forKey: "password") ?? ""
    
    var version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    @Binding var showLogin: Bool
    var body: some View {
        VStack {
            /*HStack{
                Spacer()
                Button(action:{showLogin.toggle()}) {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .foregroundColor(.gray)
                        .frame(width: 13, height: 13)
                }
            }*/
            Spacer()
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 64.0, height: 64.0)
            Text("PokaPlayer")
                .font(.title)
                .fontWeight(.light)
                .padding(.bottom, 20)
            List {
                TextField("Server", text: $server)
                    .submitLabel(.next)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                TextField("Username", text: $username)
                    .submitLabel(.next)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                    .onSubmit(login)
                    .submitLabel(.go)
                
            }.listStyle(.inset)
            
            Button(action: login, label: {
                Text("Login")
                    .padding()
                    .frame(width: 300.0)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(80)
                    .padding(10)
            })
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Spacer()
            Text("PokaNative \(version)")
                .foregroundColor(Color.gray)
                .font(.system(size: 10, weight: .regular, design: .monospaced))
        }
        .padding(20.0)
        .frame(maxWidth: .infinity)
    }
    func login(){
        // set defaults
        let defaults = UserDefaults.standard
        if server.hasSuffix("/") {
            server.removeLast()
        }
        defaults.set(server, forKey: "baseURL")
        defaults.set(username, forKey: "username")
        defaults.set(password, forKey: "password")
        // login
        PokaAPI.shared.login(username: username, password: password) { result in
            switch result {
            case .success(let LoginResponse):
                print(LoginResponse)
                showLogin = false
            case .failure(let LoginResponse):
                print(LoginResponse)
            }
        }
        
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(showLogin: .constant(true))
    }
}

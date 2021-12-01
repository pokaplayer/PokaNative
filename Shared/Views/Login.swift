//
//  Login.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/8/29.
//

import SwiftUI

struct LoginTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .padding(.leading, 13)
            .background(.systemGray6)
            .cornerRadius(13)
    }
}

struct Login: View {
    @State var server: String = defaults.string(forKey: "baseURL") ?? ""
    @State var username: String = defaults.string(forKey: "username") ?? ""
    @State var password: String = defaults.string(forKey: "password") ?? ""

    @State var showErrorAlert: Bool = false
    @State var showBundleVersion: Bool = false
    @State var loginErrorString: String = ""

    var version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    var bundleVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    @Binding var showLogin: Bool
    @State private var isLogining = false
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 88)
            Text("PokaPlayer")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            TextField("Server", text: $server)
                .submitLabel(.next)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .textFieldStyle(LoginTextFieldStyle())
            TextField("Username", text: $username)
                .submitLabel(.next)
                .autocapitalization(.none)
                .textFieldStyle(LoginTextFieldStyle())
            SecureField("Password", text: $password)
                .onSubmit(login)
                .submitLabel(.go)
                .textFieldStyle(LoginTextFieldStyle())

            Button(action: login, label: {
                if isLogining {
                    ProgressView()
                } else {
                    Text("Login")
                }
            })
            .padding(.vertical, 10)
            .frame(width: 300.0)
            .background(isLogining ? .systemGray6 : .purple)
            .foregroundColor(.white)
            .cornerRadius(13)
            .padding(.top, 20)
            .padding(.bottom, 20)
            .disabled(isLogining)

            Spacer()
            Button(action: { showBundleVersion = true }) {
                Text("PokaNative \(version)")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
            }
        }
        .frame(width: 300.0)
        .padding(20.0)
        .alert(Text(loginErrorString), isPresented: $showErrorAlert) {
            Button(action: {
                self.showErrorAlert = false
            }) {
                Text("OK")
            }
        }
        .alert(Text("Bundle version: " + bundleVersion), isPresented: $showBundleVersion) {
            Button(action: {
                self.showBundleVersion = false
            }) {
                Text("OK")
            }
        }
        .onAppear(perform: {
            if server != "" && username != "" && password != "" {
                login()
            }
        })
    }

    func login() {
        // set defaults
        let defaults = UserDefaults.standard
        if server.hasSuffix("/") {
            server.removeLast()
        }
        defaults.set(server, forKey: "baseURL")
        defaults.set(username, forKey: "username")
        defaults.set(password, forKey: "password")

        PokaAPI.shared.baseURL = URL(string: defaults.string(forKey: "baseURL") ?? "")!
        PokaAPI.shared.baseURLString = server

        isLogining = true
        // login
        PokaAPI.shared.login(username: username, password: password) { result in
            if result.success {
                showLogin = false
                isLogining = false
            } else {
                loginErrorString = result.error ?? ""
                showErrorAlert = true
                isLogining = false
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(showLogin: .constant(true))
    }
}

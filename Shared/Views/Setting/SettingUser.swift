//
//  SettingLogin.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/12/28.
//

import SwiftUI

struct SettingUser: View {
    @AppStorage("autoLogin") var autoLogin = true
    var body: some View {
        List {
            Toggle("Auto login", isOn: $autoLogin)
        }.navigationTitle("User")
    }
}

/*
 struct SettingLogin_Previews: PreviewProvider {
     static var previews: some View {
         SettingLogin()
     }
 }
 */

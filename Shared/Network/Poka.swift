//
//  Poka.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/6.
//

import Foundation

struct LoginBody: Encodable {
    let username: String
    let password: String
}
struct LoginResponse: Decodable {
    var error: String?
    var user: String?
    let success: Bool
}

class PokaAPI {
    static let shared = PokaAPI()
    
    var baseURL = URL(string: "https://music.gnehs.net")!
    
    func login(server:String,username: String,password: String, completion: @escaping (Result<LoginResponse,Error>) -> Void){
        let url = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let user = LoginBody(username:username, password:password)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let LoginResponse = try decoder.decode(LoginResponse.self, from: data)
                    print(LoginResponse)
                    completion(.success(LoginResponse))
                } catch  {
                    print(error)
                    completion(.failure(LoginResponse(success: false) as! Error))
                }
            }
        }.resume()
    }
}

//
//  Poka.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/6.
//

import Foundation
class PokaAPI {
    static let shared = PokaAPI()
    
    var baseURL = URL(string: defaults.string(forKey: "baseURL") ?? "")!
    
    var baseURLString = defaults.string(forKey: "baseURL") ?? ""
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse,Error>) -> Void){
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
    func getHome(completion: @escaping ([HomeResponse]) -> ()){
        let url = baseURL.appendingPathComponent("pokaapi/home")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let HomeResponse = try decoder.decode([HomeResponse].self, from: data)
                    print(HomeResponse)
                    completion(HomeResponse)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getAlbums(itemID: String?, source: String?, itemType: String?,completion: @escaping (AlbumsResponse) -> ()){
        var stringUrl = baseURLString + "/pokaapi/albums/"
        if itemType ?? "" == "artist" {
            stringUrl = baseURLString + "/pokaapi/artistAlbums?moduleName=\(source ?? "")&id=\(itemID ?? "")"
        } else if  itemType ?? "" == "composer" {
            stringUrl = baseURLString + "/pokaapi/composerAlbums?moduleName=\(source ?? "")&id=\(itemID ?? "")"
        }
        
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let AlbumsResponse = try decoder.decode(AlbumsResponse.self, from: data)
                    completion(AlbumsResponse)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getAlbumSongs(albumID: String, source: String, completion: @escaping (AlbumSongsResponse) -> ()){
        let stringUrl = baseURLString + "/pokaapi/album?moduleName=\(source)&id=\(albumID)"
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let AlbumSongsResponse = try decoder.decode(AlbumSongsResponse.self, from: data)
                    completion(AlbumSongsResponse)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getFolder(folderID: String?,source: String? ,completion: @escaping (Folders) -> ()){
        var stringUrl: String
        if folderID != nil && source != nil {
            stringUrl = baseURLString + "/pokaapi/folderFiles?moduleName=\(source ?? "")&id=\(folderID ?? "")"
        } else {
            stringUrl = baseURLString + "/pokaapi/folders/"
        }
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(Folders.self, from: data)
                    completion(res)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getArtist(completion: @escaping (Artists) -> ()){
        let stringUrl = baseURLString + "/pokaapi/artists/"
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(Artists.self, from: data)
                    completion(res)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getComposers(completion: @escaping (Composers) -> ()){
        let stringUrl = baseURLString + "/pokaapi/composers/"
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(Composers.self, from: data)
                    completion(res)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getPlaylists(completion: @escaping (PlaylistReponse) -> ()){
        let stringUrl = baseURLString + "/pokaapi/playlists/"
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(PlaylistReponse.self, from: data)
                    completion(res)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getPlaylistSongs(playlistID: String, source: String, completion: @escaping ([Song]) -> ()){
        let stringUrl = baseURLString + "/pokaapi/playlistSongs?moduleName=\(source)&id=\(playlistID)"
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(PlaylistSongsResponse.self, from: data)
                    completion(res.songs)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
    func getStatus(completion: @escaping (StatusReponse) -> ()){
        let stringUrl = baseURLString + "/status"
        let url =  URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(StatusReponse.self, from: data)
                    completion(res)
                } catch  {
                    print(error)
                    //completion(.failure(nil))
                }
            }
        }.resume()
    }
}

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

    func login(username: String, password: String, completion: @escaping (LoginResponse) -> Void) {
        let url = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let user = LoginBody(username: username, password: password)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let LoginResponse = try decoder.decode(LoginResponse.self, from: data)
                    completion(LoginResponse)
                } catch {
                    print("Err")
                    completion(LoginResponse(success: false))
                }
            }
            if error != nil {
                completion(LoginResponse(error: "Could not connect to the server.", success: false))
            }
        }.resume()
    }

    func getHome(completion: @escaping ([HomeResponse]) -> Void) {
        let url = baseURL.appendingPathComponent("pokaapi/home")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let HomeResponse = try decoder.decode([HomeResponse].self, from: data)
                    completion(HomeResponse)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getAlbums(itemID: String?, source: String?, itemType: String?, completion: @escaping (AlbumsResponse) -> Void) {
        var stringUrl = baseURLString + "/pokaapi/albums/"
        if itemType ?? "" == "artist" {
            stringUrl = baseURLString + "/pokaapi/artistAlbums?moduleName=\(source ?? "")&id=\(itemID ?? "")"
        } else if itemType ?? "" == "composer" {
            stringUrl = baseURLString + "/pokaapi/composerAlbums?moduleName=\(source ?? "")&id=\(itemID ?? "")"
        }

        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let AlbumsResponse = try decoder.decode(AlbumsResponse.self, from: data)
                    completion(AlbumsResponse)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getAlbumSongs(albumID: String, source: String, completion: @escaping (AlbumSongsResponse) -> Void) {
        let pokaCharacterSet = CharacterSet(charactersIn: "!*'();:@=&+$,/?%#[] ,()\"{}").inverted
        let albumIDEncoded = albumID.addingPercentEncoding(withAllowedCharacters: pokaCharacterSet)!
        let stringUrl = baseURLString + "/pokaapi/album?moduleName=\(source)&id=\(albumIDEncoded)"
        let url = URL(string: stringUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let AlbumSongsResponse = try decoder.decode(AlbumSongsResponse.self, from: data)
                    completion(AlbumSongsResponse)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getFolder(folderID: String?, source: String?, completion: @escaping (Folders) -> Void) {
        var stringUrl: String
        if folderID != nil, source != nil {
            stringUrl = baseURLString + "/pokaapi/folderFiles?moduleName=\(source ?? "")&id=\(folderID ?? "")"
        } else {
            stringUrl = baseURLString + "/pokaapi/folders/"
        }
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(Folders.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getArtist(completion: @escaping (Artists) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/artists/"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(Artists.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getComposers(completion: @escaping (Composers) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/composers/"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(Composers.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getPlaylists(completion: @escaping (PlaylistReponse) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/playlists/"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(PlaylistReponse.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getPlaylistSongs(playlistID: String, source: String, completion: @escaping ([Song]) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/playlistSongs?moduleName=\(source)&id=\(playlistID)"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(PlaylistSongsResponse.self, from: data)
                    completion(res.songs)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getRandomSongs(completion: @escaping ([Song]) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/randomSongs?rndID=" + UUID().uuidString
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(PlaylistSongsResponse.self, from: data)
                    completion(res.songs)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getStatus(completion: @escaping (StatusReponse) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/v2/info"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(StatusReponse.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getSearchResult(keyword: String, completion: @escaping (SearchReponse) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/search/?keyword=" + keyword
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(SearchReponse.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                    // completion(.failure(nil))
                }
            }
        }.resume()
    }

    func getIsSongExists(song: Song, completion: @escaping (ExistsInPlaylist) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/playlist/song/exist"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let data = try? encoder.encode(song)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(ExistsInPlaylist.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    func addSongToPlaylist(song: Song, playlistId: String, completion: @escaping () -> Void) {
        let stringUrl = baseURLString + "/pokaapi/playlist/song"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = AddToPlaylistRequest(song: song, playlistId: playlistId)

        let encoder = JSONEncoder()
        let data = try? encoder.encode(body)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }

    func createPlaylist(name: String, completion: @escaping () -> Void) {
        let stringUrl = baseURLString + "/pokaapi/playlist/create"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["name": name]

        let encoder = JSONEncoder()
        let data = try? encoder.encode(body)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }

    func getLyric(songID: String, source: String, completion: @escaping (LyricReponse) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/lyric/?moduleName=\(source)&id=\(songID)&r=\(UUID().uuidString)"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(LyricReponse.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    func searchLyric(keyword: String, completion: @escaping (LyricReponse) -> Void) {
        let stringUrl = baseURLString + "/pokaapi/searchLyrics/?keyword=\(keyword)"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(LyricReponse.self, from: data)
                    completion(res)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    func saveLyric(title: String, artist: String, songId: String, source: String, lyric: String, completion: @escaping () -> Void) {
        let stringUrl = baseURLString + "/pokaapi/lyric"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "title": title,
            "artist": artist,
            "songId": songId,
            "source": source,
            "lyric": lyric,
        ]

        let encoder = JSONEncoder()
        let data = try? encoder.encode(body)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }

    func recordSong(song: Song, completion: @escaping () -> Void) {
        let stringUrl = baseURLString + "/pokaapi/v2/record/add"
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = [
            "name": song.name,
            "artist": song.artist,
            "artistId": song.artistID,
            "album": song.album,
            "albumId": song.albumID,
            "source": song.source,
            "originalCover": song.cover,
            "id": song.id,
        ]

        let encoder = JSONEncoder()
        let data = try? encoder.encode(body)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
}

func PokaURLParser(_ u: String) -> String {
    return u.hasPrefix("http") ? u : (baseURL + u)
}

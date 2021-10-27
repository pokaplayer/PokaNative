//
//  Poka.swift
//  PokaNative
//
//  Created by 勝勝寶寶 on 2021/10/6.
//

import Foundation

// MARK: - Login
struct LoginBody: Encodable {
    let username, password: String
}
struct LoginResponse: Decodable {
    var user, error: String?
    let success: Bool
}

// MARK: - Home
struct HomeResponse: Identifiable, Decodable {
    let id = UUID()
    let title, source, icon: String
    var folders: [Folder]?
    var composers: [Composer]?
    var playlists: [Playlist]?
    var artists: [Artist]?
    var albums: [Album]?
    var songs: [Song]?
}

// MARK: - Album
struct AlbumsResponse: Decodable {
    let albums: [Album]
}

struct Album: Decodable, Identifiable, Hashable {
    let id: String
    let name, artist: String
    let type, albumID: String?
    let cover: String
    let source: String
    let owner: String?
    let year: Int?
}

struct AlbumSongsResponse: Decodable {
    let name, artist, cover: String
    let songs: [Song]
}
// MARK: - Playlist
struct PlaylistReponse: Decodable {
    let playlists: [Playlist]
    let playlistFolders: [PlaylistFolder]
}


struct PlaylistSongsResponse: Decodable { 
    let songs: [Song]
}
// MARK: - PlaylistFolder
struct PlaylistFolder: Decodable, Identifiable, Hashable {
    let name, source, id: String
    let playlists: [Playlist]
    let image: String?
}
struct Playlist: Decodable, Identifiable, Hashable { 
    let id: String
    let name, source: String
    let image: String?
    let cover: String?
}
// MARK: - Artists
struct Artists: Decodable{
    let artists: [Artist]
}

struct Artist: Decodable, Identifiable {
    let name: String
    let source: String
    let cover, id: String
}

// MARK: - Composers
struct Composers: Decodable {
    let composers: [Composer]
}

struct Composer: Decodable, Identifiable {
    let name: String
    let source: String
    let cover, id: String
}

// MARK: - Folders
struct Folders: Decodable {
    let folders: [Folder]
    let songs: [Song]
}

struct Folder: Decodable, Hashable {
    let name, source, id, cover: String
}

// MARK: - Song
struct Song: Decodable, Identifiable, Hashable { 
    let name, artist, album, source, id, url, cover: String
    let codec, lrc, artistID, albumID: String?
    let track, year, bitrate: Int?
}

// MARK: - StatusReponse
class StatusReponse: Decodable {
    let uid, version: String
    let debug: Bool
    var debugString: String?  
}

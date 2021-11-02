//
//  LyricParser.swift
//  PokaNative (iOS)
//
//  Created by 勝勝寶寶 on 2021/10/31.
//

import Foundation
import SwiftUIX

struct LyricItem {
    let id = UUID()
    var time: Double
    var text: String
}
class PokaLyricParser: ObservableObject{
    static let shared = PokaLyricParser()
    @Published var lyricItems: [LyricItem] = []
    @Published var lyricTranslated = false
    func loadLyric(lyric: String){
        // reset lyric
        self.lyricItems = []
        self.lyricTranslated = false
        // parse lyric
        let lines = lyric
            .replacingOccurrences(of: "\\n", with: "\n")
            .components(separatedBy: .newlines)
        
        for line in lines {
            parseLyric(line: line)
        }
        print(self.lyricItems)
        // check lyricTranslated
        if self.lyricItems[self.lyricItems.count - 1].time == self.lyricItems[self.lyricItems.count - 2].time {
            self.lyricItems[self.lyricItems.count - 1].time += 100
            self.lyricTranslated = true
        }
    }
    private func parseHeader(prefix: String, line: String) -> String? {
        if line.hasPrefix("[" + prefix + ":") && line.hasSuffix("]") {
            let startIndex = line.index(line.startIndex, offsetBy: prefix.count + 2)
            let endIndex = line.index(line.endIndex, offsetBy: -1)
            return String(line[startIndex..<endIndex])
        } else {
            return nil
        }
    }
    private func parseLyric(line: String)  {
        var cLine = line
        while(cLine.hasPrefix("[")) {
            guard let closureIndex = cLine.range(of: "]")?.lowerBound else {
                break
            }
            
            let startIndex = cLine.index(cLine.startIndex, offsetBy: 1)
            let endIndex = cLine.index(closureIndex, offsetBy: -1)
            let amidString = String(cLine[startIndex..<endIndex])
            
            let amidStrings = amidString.components(separatedBy: ":")
            var hour:TimeInterval = 0
            var minute: TimeInterval = 0
            var second: TimeInterval = 0
            if amidStrings.count >= 1 {
                second = TimeInterval(amidStrings[amidStrings.count - 1]) ?? 0
            }
            if amidStrings.count >= 2 {
                minute = TimeInterval(amidStrings[amidStrings.count - 2]) ?? 0
            }
            if amidStrings.count >= 3 {
                hour = TimeInterval(amidStrings[amidStrings.count - 3]) ?? 0
            }
            
            cLine.removeSubrange(line.startIndex..<cLine.index(closureIndex, offsetBy: 1))
            self.lyricItems.append(LyricItem(time: hour * 3600 + minute * 60 + second,text: cLine))
        }
    }
    func getCurrentLineIndex(time: Double) -> Int {
        for (index,item) in self.lyricItems.enumerated()   {
            if item.time >= time {
                return index - 1 >= 0 ? index - 1 : 0
            }
        }
        return 0
    }
}

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

class PokaLyricParser: ObservableObject {
    static let shared = PokaLyricParser()
    @Published var lyricItems: [LyricItem] = []
    @Published var lyricTranslated = false
    func loadLyric(lyric: String) {
        // reset lyric
        lyricItems = []
        lyricTranslated = false
        // parse lyric
        let lines = lyric
            .replacingOccurrences(of: "\\n", with: "\n")
            .components(separatedBy: .newlines)
        
        for line in lines {
            parseLyric(line: line)
        }
        // check lyricTranslated
        if lyricItems.count > 2 {
            if lyricItems[lyricItems.count - 1].time == lyricItems[lyricItems.count - 2].time {
                lyricItems[lyricItems.count - 1].time += 100
                lyricTranslated = true
            }
        }
    }
    
    private func parseHeader(prefix: String, line: String) -> String? {
        if line.hasPrefix("[" + prefix + ":"), line.hasSuffix("]") {
            let startIndex = line.index(line.startIndex, offsetBy: prefix.count + 2)
            let endIndex = line.index(line.endIndex, offsetBy: -1)
            return String(line[startIndex ..< endIndex])
        } else {
            return nil
        }
    }
    
    func timeStampToTime(timeStamp: String) -> Double {
        let str: String = timeStamp
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
        let tmp: [String] = str.components(separatedBy: ":")
        let min = Double(tmp[0])! * 60
        let sec = Double(tmp[1])!
        let res: Double = min + sec
        return res
    }
    
    private func parseLyric(line: String) {
        let chomp: String = line.replacingOccurrences(of: "\r", with: "")
        let regex = try! NSRegularExpression(pattern: "\\[[0-9]{1,}\\:[0-9]{1,2}(\\.[0-9]{1,})?\\]", options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex.matches(in: chomp, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, chomp.count))
        
        if matches.count > 0 {
            // find the lyrics str first
            let last = matches.last! as NSTextCheckingResult
            
            let text = (chomp as NSString)
                .substring(with: NSMakeRange(last.range.location + last.range.length, chomp.count - (last.range.location + last.range.length)))
                .trimmingCharacters(in: .whitespaces)
            
            for match in matches {
                let temp = (chomp as NSString).substring(with: match.range)
                let time = timeStampToTime(timeStamp: temp)
                lyricItems.append(LyricItem(time: time, text: text))
            }
        }
    }
    
    func getCurrentLineIndex(time: Double) -> Int {
        var res = 0
        for (index, item) in lyricItems.enumerated() {
            if item.time <= time + 0.2 {
                res = index
            }
        }
        return res
    }
}

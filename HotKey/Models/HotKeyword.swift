// Models/HotKeyword.swift

import Foundation

struct HotKeywordResponse: Codable {
    let data: HotKeywordData
}

struct HotKeywordData: Codable {
    let items: [HotKeyword]
}

public struct HotKeyword: Codable {
    let name: String
    let icon: String
    
    public init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}

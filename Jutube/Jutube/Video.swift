//
//  Video.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import Foundation

struct Video : Decodable{
    
    var videoId = ""
    var channelId = ""
    var title = ""
    var description = ""
    var thumbnail = ""
    var published = ""
    
    enum CodingKeys: String, CodingKey {
        case snippet
        case thumbnails
        case high
        case resourceId
        
        case videoId
        case channelId
        case title
        case description
        case thumbnail = "url"
        case published = "publishedAt"
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        
        // Parse title
        self.title = try snippetContainer.decode(String.self, forKey: .title)
    }
}

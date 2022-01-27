//
//  Video.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import Foundation

// We use the Decodable Protocol so that we can decode the json into Video
struct Video {
    
    var videoId = ""
    var channelTitle = ""
    var title = ""
    var description = ""
    var thumbnailUrl = ""
    var published = ""
}

class Model {
    var videos = [Video]()
}

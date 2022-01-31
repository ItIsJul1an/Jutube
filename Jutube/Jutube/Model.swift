//
//  Video.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import Foundation

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

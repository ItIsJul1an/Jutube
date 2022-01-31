//
//  Constants.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import Foundation

struct Constants {
    static var API_KEY = "AIzaSyBOFKMdgtZOnzAEbSBhAQAELvei_FLeH1w"
    
    // q= -> search string
    static var API_URI = "https://youtube.googleapis.com/youtube/v3/search?key=\(API_KEY)&type=video&part=snippet&maxResults=20&q=Kali+Linux"

    static var VIDEOCELL_ID = "video"
}

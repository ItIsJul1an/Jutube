//
//  Constants.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import Foundation

struct Constants {
    static var API_KEY = "AIzaSyAD-591QSo_WzJhobN_d29mHj4M9kE1aQQ"
    
    // q= -> search string
    static var API_URI = "https://youtube.googleapis.com/youtube/v3/search?key=\(API_KEY)&type=video&part=snippet&maxResults=10&q="

    static var VIDEOCELL_ID = "video"
}

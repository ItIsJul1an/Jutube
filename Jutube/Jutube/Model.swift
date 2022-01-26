//
//  Video.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import Foundation

class Model {
    
    
    func getVideo() {
        // Create a URL object
        let url = URL(string: Constants.API_URI)
        
        guard url != nil else {
            print("invalid url")
            return
        }
        
        // Get a URLSession object
        let session = URLSession.shared
        
        // Get a data task from the URLSession object
        let dataTask = session.dataTask(with: url!) {
            (data, response, error) in
            
            // Check if there were any errors
            if error != nil || data == nil {
                print("error ocurred")
                return
            }
            
            // Parsin the data into video objects
        }
        
        // Kick off the task
        dataTask.resume()
    }
}

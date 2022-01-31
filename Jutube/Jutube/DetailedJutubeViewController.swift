//
//  ViewController.swift
//  Jutube
//
//  Created by Julian Berger on 31.01.22.
//

import UIKit

class DetailedJutubeViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var queue = DispatchQueue(label: "downloadImage")
    var video = Video()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = video.title
        self.channelTitleLabel.text = video.channelTitle
        self.descriptionLabel.text = video.description
        
        self.asyncDownloadImage()
    }
    
    func asyncDownloadImage(){
        let url = URL(string: video.thumbnailUrl)
        
        if (url == nil){
            return
        }
        
        queue.async {
            let data = try? Data(contentsOf: url!)
            
            if (data == nil) {
                return
            }
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func onClick(_ sender: Any) {
        if let youtubeURL = URL(string: "youtube://\(video.videoId)"),
           UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(video.videoId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
}

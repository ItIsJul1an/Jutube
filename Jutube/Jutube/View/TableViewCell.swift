//
//  TableViewCell.swift
//  Jutube
//
//  Created by Julian Berger on 28.01.22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var video:Video?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(_ video:Video) {
        
        self.video = video
        
        // Set the title and date label
        self.titleLabel.text = video.title
        self.dateLabel.text = video.published
        
        // Set the thumbnail
        guard self.video?.thumbnailUrl != "" else {
            return
    }
        
        // Download the thumbnail data
        let url = URL(string: self.video!.thumbnailUrl)
        
        // Get the shared URL Session object
        let session = URLSession.shared
        
        // Create a data task
        let dataTask = session.dataTask(with: url!){
            (data, response, error) in
            
            if error == nil && data != nil{
                
                // Check that the download url matches the video thumbnail url that this cell is currently set to display
                if url!.absoluteString != self.video?.thumbnailUrl {
                    // Video cell has been recycled for another video and no longer matches the thumbnail that was downloaded
                    return
                }
                
                // Create the image object
                let image = UIImage(data: data!)
                
                // Set the imageview
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            }
        }
        
        // Start data task
        dataTask.resume()
}
}

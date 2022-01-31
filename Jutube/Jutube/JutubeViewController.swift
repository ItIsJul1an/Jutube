//
//  CustomViewController.swift
//  Jutube
//
//  Created by Julian Berger on 31.01.22.
//

import UIKit

class JutubeCustomCell: UITableViewCell{
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var publishedLabel: UILabel!
}

class JutubeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var queue = DispatchQueue(label: "fetchData")
    var currentVideo = Video()
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func download(url: URL) {
        queue.async {
            let tempModel = self.asyncDownload(url: url)
            
            DispatchQueue.main.async {
                
                self.model = tempModel
                self.tableView.reloadData()
            }
        }
    }
    
    func asyncDownload(url: URL) -> Model {
        let model = Model()
        
        if let data = try? Data(contentsOf: url) {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []){
                if let obj = jsonObject as? [String: Any] {
                    if let items = obj["items"] as? [ [String:Any] ] {
                        for item in items {
                            var video = Video()
                            if let id = item["id"] as? [String:Any] {
                                video.videoId = id["videoId"] as! String
                            }
                            
                            if let snippet = item["snippet"] as? [String:Any] {
                                video.published = snippet["publishedAt"] as! String
                                video.channelTitle = snippet["channelTitle"] as! String
                                video.title = snippet["title"] as! String
                                video.description = snippet["description"] as! String
                                
                                if let thumbnails = snippet["thumbnails"] as? [String:Any] {
                                    if let high = thumbnails["high"] as? [String:Any] {
                                        video.thumbnailUrl = high["url"] as! String
                                    }
                                }
                            }
                            
                            model.videos.append(video)
                        }
                    }
                }
            } else{
                print("failed to parse json")
            }
        } else {
            print("failed to load data")
        }
        
        return model
    }
    
    @IBAction func onClick(_ sender: Any) {
        if self.searchTextField.text != nil {
            if let url = URL(string: Constants.API_URI + self.searchTextField.text!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)) {
                download(url: url)
            }
        }
    }
    
    // MARK: UITableViewDataSource Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.model.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.VIDEOCELL_ID, for: indexPath) as! JutubeCustomCell
        
        let video = model.videos[indexPath.row]
        
        let url = URL(string: video.thumbnailUrl)
        
        queue.async {
            let data = try? Data(contentsOf: url!)
            
            if (data == nil) {
                return
            }
            
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = UIImage(data: data!)
            }
        }
        
        cell.publishedLabel.text = video.published
        
        return cell
    }
    
    // OnRowClick()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath)")
        self.currentVideo = model.videos[indexPath.row]
        performSegue(withIdentifier: "detailedInformation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if let viewController = segue.destination as? DetailedJutubeViewController {
            viewController.video = self.currentVideo
        }
    }
}

//
//  TableViewController.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var queue = DispatchQueue(label: "fetchData")
    var currentVideo = Video()
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: Constants.API_URI) {
            download(url: url)
        }
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.model.videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.VIDEOCELL_ID, for: indexPath)
        
        let video = model.videos[indexPath.row]
        
        cell.textLabel?.text = video.title
        cell.detailTextLabel?.text = video.description
        
        return cell
    }
    
    // OnRowClick()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath)")
        self.currentVideo = model.videos[indexPath.row]
        performSegue(withIdentifier: "detailedInformation", sender: self)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if let viewController = segue.destination as? ViewController {
            viewController.video = self.currentVideo
        }
    }
}

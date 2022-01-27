//
//  TableViewController.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var queue = DispatchQueue(label: "fetchData")
    var video = Video()
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
                
                self.video = tempModel
                self.tableView.reloadData()
                
                print("loaded data")
            }
        }
    }
    
    func asyncDownload(url: URL) -> Video {
        var currentVideo = Video()
        
        if let data = try? Data(contentsOf: url) {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []){
                if let obj = jsonObject as? [String: Any] {
                    if let items = obj["items"] as? [ [String:Any] ] {
                        for item in items {
                            if let id = item["id"] as? [String:Any] {
                                currentVideo.videoId = id["videoId"] as! String
                            }
                            
                            if let snippet = item["snippet"] as? [String:Any] {
                                currentVideo.published = snippet["publishedAt"] as! String
                                currentVideo.channelTitle = snippet["channelTitle"] as! String
                                currentVideo.title = snippet["title"] as! String
                                currentVideo.description = snippet["description"] as! String
                                
                                if let thumbnails = snippet["thumbnails"] as? [String:Any] {
                                    if let high = thumbnails["high"] as? [String:Any] {
                                        currentVideo.thumbnailUrl = high["url"] as! String
                                    }
                                }
                            }
                            
                            self.model.videos.append(currentVideo)
                        }
                    }
                }
            } else{
                print("failed to parse json")
            }
        } else {
            print("failed to load data")
        }
        
        return currentVideo
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "video", for: indexPath)
        
        let video = model.videos[indexPath.row]
        
        cell.textLabel?.text = person.personName
        cell.detailTextLabel?.text = person.uri
        
        return cell
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

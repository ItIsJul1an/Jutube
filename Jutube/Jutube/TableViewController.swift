//
//  TableViewController.swift
//  Jutube
//
//  Created by Julian Berger on 26.01.22.
//

import UIKit

class TableViewController: UITableViewController {

    var queue = DispatchQueue(label: "fetchData")
    var model = Model()
    var currentVideo: Video?
    
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
                print("done")
            }
        }
    }
    
    func asyncDownload(url: URL) -> Model{
        var model = Model()
        
        if let data = try? Data(contentsOf: url) {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []){
                if let array = jsonObject as? [[String: Any]] {
                    model = parseArray(array: array)
                }
            } else{
                print("failed to parse json")
            }
        } else {
            print("failed to load data")
        }
        
        return model
    }
    
    func parseArray(array: [[String: Any]]) -> Model {
        var model = Model()
        
        for obj in array {
            //let video = Video()
            let title = obj["title"] as! String
            print(title)
            
            //model.videos.append(video)
        }
        
        return model
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

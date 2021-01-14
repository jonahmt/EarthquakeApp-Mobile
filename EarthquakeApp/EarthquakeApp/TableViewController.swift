//
//  TableViewController.swift
//  EarthquakeApp
//
//  Created by Mobile on 11/13/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var features:[Feature] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        // Summary page:
        // https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php

        // All quakes, last 30 days
        // https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson

        // Significant quakes, last 30 days
        // https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.geojson

        guard let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.geojson") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)

        /*
            Notes from Apple about using URLSession, the shared Singleton, dataTask(with:)
            and especially, why you need to use DispatchQueue to put the data back on the
            main thread. See
            
            https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
            
            "Important
            
            The completion handler is called on a different Grand Central Dispatch queue than the one that created the task. Therefore, any work that uses data or error to update the UI — like updating webView — should be explicitly placed on the main queue, as shown here.
            "
            */

        let session = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let jdata = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(EarthquakeData.self, from: jdata)
                    DispatchQueue.main.async {
                        self.features = decodedResponse.features
                        self.tableView.reloadData()
                        self.navigationItem.title = decodedResponse.metadata.title
                    }
                } catch let jsonError as NSError {
                    print("JSON decode failed: \(jsonError)")
                }
            }
            else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            
        }
        session.resume()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return features.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "earthquakeCell", for: indexPath)

        // Configure the cell...
        
        let locLabel = cell.viewWithTag(1) as! UILabel
        let imageView = cell.viewWithTag(2) as! UIImageView
        locLabel.text = features[indexPath.row].properties.place
        var eqMagnitude = features[indexPath.row].properties.mag.rounded()
        if eqMagnitude > 5.0 {
            eqMagnitude = 5.0
        } else if eqMagnitude < 2.0 {
            eqMagnitude = 2.0
        }
        imageView.image = UIImage(named: String(eqMagnitude))

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
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detailVC") as! ViewController
        detailVC.feature = features[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

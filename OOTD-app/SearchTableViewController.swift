//
//  SearchTableViewController.swift
//  OOTD-app
//
//  Created by Dana Kirsanov on 12/11/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchTableViewController: UITableViewController,  UISearchResultsUpdating {
    
    @IBOutlet var searchTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var outfitArray = [NSDictionary?]()
    var filteredOutfits = [NSDictionary?]()
    var databaseRef = FIRDatabase.database().reference()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change navigation color
        self.navigationController!.navigationBar.alpha = 0
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 245/255, green: 94/255, blue: 97/255, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar

    databaseRef.child("posts").queryOrdered(byChild:"title").observe(.childAdded, with: { (snapshot) in
        
        self.outfitArray.append(snapshot.value as? NSDictionary)
        
        //insert the rows
        self.searchTableView.insertRows(at: [IndexPath(row:self.outfitArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
        
    }) { (error) in
        print(error.localizedDescription)
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredOutfits.count
        } else {
            return self.outfitArray.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let outfit : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            outfit = filteredOutfits[indexPath.row]
        } else {
            outfit = self.outfitArray[indexPath.row]
        }
        
        cell.textLabel?.text = outfit?["title"] as? String
        cell.detailTextLabel?.text = outfit?["content"] as? String

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func updateSearchResults(for searchController: UISearchController) {
        //update search results
        filterContent(searchText: self.searchController.searchBar.text!)
        
    }
    
    func filterContent(searchText:String){
        self.filteredOutfits = self.outfitArray.filter{ outfit in
            
            let post = outfit!["content"] as? String 
            
            return(post?.lowercased().contains(searchText.lowercased()))!
        }
        
        tableView.reloadData()
    }
}

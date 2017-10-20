//
//  RestaurantTableViewController.swift
//  iSchool Exchange
//
//  Created by ChenYuwei on 2017/9/26.
//  Copyright © 2017年 ChenYuwei. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    var searchResults:[RestaurantMO] = []
    
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue){
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }

    var restaurants:[RestaurantMO] = []
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            .plain, target: nil, action: nil)
        
        navigationController?.hidesBarsOnSwipe = true
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
       
        //Retrieve object from Core Data
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest:
                fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil,
                              cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    restaurants = fetchedObjects
                }
            }
            catch {
                print(error)
            }
        }
        
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        //The first line assigns the current class as the search results updater.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search Restaurant..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(_ animated: Bool){
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //Obviously, the app should display the search results only when the search controller is active.
        if searchController.isActive {
            return searchResults.count
        }
        else {
            return restaurants.count;
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive{
            return false
        }
        else {
            return true
        }
    }
    
        
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        //Determine if we get the restaurant from search result or the original array
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]

        // Configure the cell...
        cell.nameLabel?.text = restaurant.name
        cell.typeLabel?.text = restaurant.type
        cell.locationLabel?.text = restaurant.location
        cell.thumbnailImageView?.image = UIImage(data: restaurant.image! as Data);
        
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            restaurants.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: {(action, indexPath) -> Void in
            let defaultText = "Just Check in at " + self.restaurants[indexPath.row].name!
            
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image! as Data){
               let activityController = UIActivityViewController(activityItems: [defaultText,imageToShare], applicationActivities: nil)
            
               self.present(activityController,animated: true,completion: nil)
            }
        })
        
        shareAction.backgroundColor = UIColor(red: 160/255, green: 133/255, blue: 204/255, alpha: 1)
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) -> Void in

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                
                appDelegate.saveContext()
            }
            
//            self.restaurants.remove(at: indexPath.row)            
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        deleteAction.backgroundColor = UIColor(red: 202/255, green: 202/255, blue: 203/255, alpha: 1)
        
        return [shareAction,deleteAction]

    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
            
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            
        case .delete:
            if let indexPath = newIndexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .update:
            if let indexPath = newIndexPath{
             tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects{
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        tableView.endUpdates()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        }
    }
    
    
    func filterContent(for searchText: String){
        searchResults = restaurants.filter({(restaurant) -> Bool in
            if let name = restaurant.name, let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            

            
            return false;
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
 

}

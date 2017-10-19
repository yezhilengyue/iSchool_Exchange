//
//  RestaurantDetailViewController.swift
//  iSchool Exchange
//
//  Created by ChenYuwei on 2017/10/10.
//  Copyright © 2017年 ChenYuwei. All rights reserved.
//
import MapKit
import UIKit

class RestaurantDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var restaurantImageView: UIImageView!
    
    @IBAction func close(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func ratingButtonTapped(segue:UIStoryboardSegue){
        if let rating = segue.identifier{
            restaurant.isVisited = true
            
            switch rating {
            case "great" : restaurant.rating = "Absolutely love it! Must try."
            case "good": restaurant.rating = "Pretty good."
            case "dislike": restaurant.rating = "I don't like it."
            default:break
            }
        }
        
        tableView.reloadData()
    }
    
    var restaurant: RestaurantMO!

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantImageView.image = UIImage(data: restaurant.image! as Data)
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue:
            240.0/255.0, alpha: 0.2)
        //tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue:
            240.0/255.0, alpha: 0.8)
        
        title = restaurant.name
        
        navigationController?.hidesBarsOnSwipe = false
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
    
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error as Any)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotaion = MKPointAnnotation()
                
                if let location = placemark.location{
                    annotaion.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotaion)
                    
                    //Here we use the MKCoordinateRegionMakeWithDistance function to adjust the initial zoom level of the map to 250m radius
                    let region = MKCoordinateRegionMakeWithDistance(annotaion.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func showMap(){ //target function
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "t_Cell", for:indexPath) as! RestaurantDetailTableViewCell
        
        switch indexPath.row{
//        case 0:
//            cell.fieldLabel.text = ""
//            cell.valueLabel.text = ""
            
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
            
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
            
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
            
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before. \(String(describing: restaurant.rating))" : "No"
            
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showReview" {
            let destination = segue.destination as! ReviewViewController
            destination.restaurant = restaurant
        }
        
        if segue.identifier == "showMap"{
            let destination = segue.destination as! MapViewController
            destination.restaurant = restaurant
        }

    }
    

}

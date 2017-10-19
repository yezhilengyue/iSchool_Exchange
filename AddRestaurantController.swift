//
//  AddRestaurantController.swift
//  iSchool Exchange
//
//  Created by ChenYuwei on 2017/10/13.
//  Copyright © 2017年 ChenYuwei. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var locationTextField:UITextField!
    @IBOutlet var yesButton:UIButton!
    @IBOutlet var noButton:UIButton!
    
    //var restaurant: Restaurant?
    var restaurant: RestaurantMO!
    var isVisited = true
    
    @IBAction func toggleBeenHereButton(sender: UIButton){
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor.red
            noButton.backgroundColor = UIColor.gray
        }
        else if sender == noButton {
            isVisited = false
            yesButton.backgroundColor = UIColor.gray
            noButton.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func save(sender: UIButton){
        if nameTextField.text == "" || typeTextField.text == "" || locationTextField.text == nil{
            let alert = UIAlertController(title: "Oops", message: "Invalid input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            //Get the context info of data model
            //To access the variable, we have to first get a reference to AppDelegate 
            restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            restaurant.location = locationTextField.text
            restaurant.isVisited = isVisited
            
            if let restaurantImage = photoImageView.image{
                if let imageData = UIImagePNGRepresentation(restaurantImage) {
                    restaurant.image = NSData(data: imageData)
                }
            }
            
            print("Saving data to context...")
            appDelegate.saveContext()
        }
        
       
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //switch indexPath.ro
        
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    
    //The above code assigns the image view with the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
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

}

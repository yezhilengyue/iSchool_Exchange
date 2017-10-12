//
//  ReviewViewController.swift
//  iSchool Exchange
//
//  Created by ChenYuwei on 2017/10/12.
//  Copyright © 2017年 ChenYuwei. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var restaurantImage: UIImageView!

    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var closeButton: UIButton!
    
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurant = restaurant{
            restaurantImage.image = UIImage(named: restaurant.image)
        }
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //containerView.transform = CGAffineTransform.init(scaleX:0, y:0)
        
        let scaleTransform = CGAffineTransform.init(scaleX:0, y:0)
        let translateTransform = CGAffineTransform.init(translationX: 0, y:-1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform

        // Do any additional setup after loading the view.
        
        let buttontranslateTransform = CGAffineTransform.init(translationX: 1000, y: 0)
        closeButton.transform = buttontranslateTransform
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            self.closeButton.transform = CGAffineTransform.identity
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

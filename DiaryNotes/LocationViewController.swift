//
//  LocationViewController.swift
//  DiaryNotes
//
//  Created by Minh Huy Tran on 13/5/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


extension UIViewController {
    
    func performSegueToReturnBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


class LocationViewController: UIViewController, CLLocationManagerDelegate {

    //our Map
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapGEOText: UILabel! //author text.. i just was lazy to change the name
    @IBOutlet weak var IDText: UILabel!
    
    @IBOutlet weak var logoLbel: UIImageView!
    
    @IBOutlet weak var decsLabel: UILabel!
    
    
    @IBOutlet weak var doneButton: UIButton!
    
    //declare our variable
    
    //func to call every single time user change their location
  
    
    @IBAction func goBackAction(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //just shape my button's corner for better look
        doneButton.layer.cornerRadius = 4
        
        
        //i created a chain animation 
        mapView.alpha = 0
        mapGEOText.alpha = 0
        IDText.alpha = 0
        logoLbel.alpha = 0
        decsLabel.alpha = 0
        //done setting up label alpha for animation
        
        
        UIView.animate(withDuration: 1, animations: {
            self.mapView.alpha = 1
            
        }) { (true) in
            self.firstA()
        }
        
        
        
        //map code here
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        //we can access the latitude, velocity, longtitue as well
        
        //my location address i want to show up for my introduction
        // -37.846312, 145.115174 stands for deakin university
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-37.846312, 145.115174)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region,animated: true)
        
        //create our annotation
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = myLocation
        annotation.title = "DEAKIN UNIVERSITY"
        annotation.subtitle = "Burwood Highway, Burwood, Melbourne, Victoria"
        mapView.addAnnotation(annotation)
        
        
        //show geometry address on label we created in location view controller
        
        // Do any additional setup after loading the view.
    }

   /* //i created a chain animation
    mapView.alpha = 0
    mapGEOText.alpha = 0
    IDText.alpha = 0
    logoLbel.alpha = 0
    decsLabel.alpha = 0
    */
    //our chain animation function here
    func firstA() {
        UIView.animate(withDuration: 2, animations: {
            self.logoLbel.alpha = 1
        }, completion: { (true) in
            self.secondA()
        })
    }
    
    func secondA() {
        
        UIView.animate(withDuration: 2, animations: {
            self.mapGEOText.alpha = 1
        }) { (true) in
            self.thirdA()
        }
        
    }
    
    func thirdA() {
        
        UIView.animate(withDuration: 2, animations: {
            self.IDText.alpha = 1
        }) { (true) in
            self.fourthA()
        }
    }
    
    func fourthA() {
        UIView.animate(withDuration: 2, animations: {
            self.decsLabel.alpha = 1
        })
        
    }
    //------
    
    
    
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



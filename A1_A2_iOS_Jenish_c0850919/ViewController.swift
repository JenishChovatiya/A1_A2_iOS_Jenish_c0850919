//
//  ViewController.swift
//  A1_A2_iOS_Jenish_c0850919
//
//  Created by user219793 on 5/24/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var userMapView: MKMapView!
    
    
    //applay location manager
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        //asking from user regarding permission to allow for using location
        locationManager.requestWhenInUseAuthorization()
        
        //for automatically updating user location
        locationManager.startUpdatingLocation()
    }


}

//create extenstion for viewControllar
extension ViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region  = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        userMapView.setRegion(region, animated: true)
        userMapView.showsUserLocation = true
    }
}

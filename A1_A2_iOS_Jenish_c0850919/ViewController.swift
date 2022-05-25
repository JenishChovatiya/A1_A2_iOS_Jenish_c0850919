//
//  ViewController.swift
//  A1_A2_iOS_Jenish_c0850919
//
//  Created by user219793 on 5/24/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var userMapView: MKMapView!
    
    var arrayCity: [MKMapItem] = []
    
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
        
        
        //when user longpressed on screen
        let userLongPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(whenpressed))
        self.userMapView.addGestureRecognizer(userLongPressedRecognizer)
    }

    @objc func whenpressed(sender: UILongPressGestureRecognizer)
        {
            let alert = UIAlertController(title: "Want to add this location", message: "Add !!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action: UIAlertAction!)
                in
                var annotations = [MKAnnotation]()
                
                for i in 0..<self.arrayCity.count
                {
                    let annotation = MKPointAnnotation()
                    if (i == 0)
                    {
                        annotation.title = "A"
                    }
                    else if(i == 1)
                    {
                        annotation.title = "B"
                    }
                    else if(i == 2)
                    {
                        annotation.title = "C"
                    }
                    else
                    {
                        annotation.title = ""
                    }
                    annotation.coordinate = CLLocationCoordinate2D(latitude: self.arrayCity[i].placemark.coordinate.latitude, longitude: arrayCity[i].placemark.coordinate.longitude)
                    annotations.append(annotation)
                }
                userMapView.addAnnotations(annotations)

            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in }))
            
            present(alert, animated: true, completion: nil)
        }
    
}

//create extenstion for viewControllar
extension ViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
       let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region  = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        userMapView.setRegion(region, animated: true)
        userMapView.showsUserLocation = true
        
        
    }
}

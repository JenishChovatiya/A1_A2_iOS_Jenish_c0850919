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
    
    var addpolygon : MKPolygon? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        
        //asking from user regarding permission to allow for using location
        locationManager.requestWhenInUseAuthorization()
        
        //for automatically updating user location
        locationManager.startUpdatingLocation()
        
        
        func insertingPolygon()
        {
            var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            
            for i in 0..<arrayCity.count
            {
                points.append(arrayCity[i].placemark.coordinate)
            }
            let polygon = MKPolygon(coordinates: points, count: points.count)
            self.addpolygon = polygon
            userMapView.addOverlay(polygon)
            
            
        }
        
        
        //when user longpressed on screen
        let userLongPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(whenpressed))
        self.userMapView.addGestureRecognizer(userLongPressedRecognizer)
    	}

    @objc func whenpressed(sender: UILongPressGestureRecognizer)
        {
            let alert = UIAlertController(title: "Want to add this location", message: "Add !!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!)		
                in
                let searcscreen = self.storyboard?.instantiateViewController(withIdentifier: "AddyourCityVcViewController") as! AddyourCityVcViewController
                searcscreen.viewofMap = self.userMapView
                searcscreen.delegate = self
                self.navigationController?.pushViewController(searcscreen, animated: true)
                
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

extension ViewController: resultaftersearch
{
    func viewListofCity(item: MKMapItem)
    {
        arrayCity.append(item)
        
        //applaying annotation
        var annotations = [MKAnnotation]()
        
        
        //applaying loop
        for i in 0..<arrayCity.count
        {
            let annotation = MKPointAnnotation()
            if i == 0
            {
                annotation.title = "A"
            }
            else if i == 1
            {
                annotation.title = "B"
            }
            else if i == 2
            {
                annotation.title = "c"
            }
            else
            {
                annotation.title = "other"
            }
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: arrayCity[i].placemark.coordinate.latitude, longitude: arrayCity[i].placemark.coordinate.longitude)
            
            annotations.append(annotation)
            
        }
        userMapView.addAnnotations(annotations)
        userMapView.addAllItems(in: annotations, andShow: true)
    }
}

extension MKMapView
{
    func addAllItems()
    {
        var zoom:MKMapRect = MKMapRect.null;
        for annotation in annotations
        {
            let poinforAnnotation = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: poinforAnnotation.x, y: poinforAnnotation.y, width: 0.5, height: 0.5);
            zoom = zoom.union(rect);
        }
        setVisibleMapRect(zoom, edgePadding: UIEdgeInsets(top:150, left:150, bottom: 150, right: 150), animated: true)
    }
    
    
    func addAllItems(in annotations: [MKAnnotation], andShow show: Bool)
    {
        var zoom:MKMapRect = MKMapRect.null
        
        for annotation in annotations
        {
            let annoPoint = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: annoPoint.x, y: annoPoint.y, width: 0.5, height: 0.5)
            
            if zoom.isNull
            {
                zoom = rect
            }
            else
            {
                zoom = zoom.union(rect)
            }
        }
        if(show)
        {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoom, edgePadding: UIEdgeInsets(top: 150, left: 150, bottom: 150, right: 150), animated: true)
    }
}

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

   
    //connecting all the items
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var userMapView: MKMapView!
    

    	
    var arrayCity: [MKMapItem] = []
    
    //applay location manager
    var locationManager: CLLocationManager!
    
    let thingg = UINavigationItem()
    
    var addpolygon : MKPolygon? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        
        //asking from user regarding permission to allow for using location
        locationManager.requestWhenInUseAuthorization()
        
        //for automatically updating user location
        locationManager.startUpdatingLocation()
        
        
        //double  tap
        let userdoubletap = UITapGestureRecognizer(target: self, action: #selector(doubletaped))
        userdoubletap.numberOfTapsRequired = 2
        userdoubletap.numberOfTouchesRequired = 1
        self.userMapView.addGestureRecognizer(userdoubletap)
        
        
        //when user longpressed on screen
        let userLongPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(whenpressed))
        self.userMapView.addGestureRecognizer(userLongPressedRecognizer)
        
        thingg.rightBarButtonItem = UIBarButtonItem(title: "GO", style: .plain, target: self, action: #selector(whentappedonpho))
        self.navigationBar.items = [thingg]
        
    }//view did load over here
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        checkforRouteOption()
    }
    
    func checkforRouteOption() {
        if arrayCity.count > 2 {
            self.navigationBar.items = [thingg]
        }
        else
        {
            self.navigationBar.items?.removeAll()
        }
    }
    
    
    
    @objc func whentappedonpho()
    {
        if userMapView.overlays.last != nil
        {
            self.userMapView.removeOverlay(userMapView.overlays.last!)
            addpolygon = nil
        }
        
        for i in 0..<arrayCity.count
        {
            if i == 0
            {
                displayRought(source: locationManager.location!.coordinate, totheDestination: arrayCity[i].placemark.coordinate, title: "A")
            }
            else if(i == 1)
            {
                displayRought(source: arrayCity[i-1].placemark.coordinate, totheDestination: arrayCity[i].placemark.coordinate, title: "B")
            }
            else if(i == 2)
            {
                displayRought(source: arrayCity[i-1].placemark.coordinate, totheDestination: arrayCity[i].placemark.coordinate, title: "C")
            }
        }
    }
    
    
    //this function will display the rout
    func displayRought(source : CLLocationCoordinate2D, totheDestination : CLLocationCoordinate2D, title: String)
    {
        let fromLocation = source
        let destinationPlace = totheDestination
        let fromLocationPlaceMaker = MKPlacemark(coordinate: fromLocation)
        let destinationlaceMark = MKPlacemark(coordinate: destinationPlace)
        
        let requestForThedirection = MKDirections.Request()
        
        requestForThedirection.source = MKMapItem(placemark: fromLocationPlaceMaker)
        requestForThedirection.destination = MKMapItem(placemark: destinationlaceMark)
        requestForThedirection.transportType = .automobile
        
        let directions = MKDirections(request: requestForThedirection)
        directions.calculate
        {
            (responses, errors) in
            guard let responseforTheDirection = responses
            else
            {
                if let error = errors
                {
                    print ("Getting some errors ==\(error.localizedDescription)")
                }
                return
            }
            
            //this block will get the rough and assign that to our route variable
            let route = responseforTheDirection.routes[0]
            route.polyline.title = title
            
            
            
            //now applaying that route to are map view
            self.userMapView.addOverlay(route.polyline, level: .aboveRoads)
            
            
            
            //now setting that rout for fitting it between two locations
            
            let rectt = route.polyline.boundingMapRect
            self.userMapView.setRegion(MKCoordinateRegion(rectt), animated: true)

        }
 
    }
    
  
    @objc func whenpressed(sender: UILongPressGestureRecognizer)
        {
            //alert message for displaying want to add or not ?
            
            let alert = UIAlertController(title: "Want to add this location", message: "Add !!", preferredStyle: .alert)
            
            
            //when user will press yes than it will redirectuser to another page for searching city name
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action: UIAlertAction!)
                in
                let searcscreen = self.storyboard?.instantiateViewController(withIdentifier: "AddyourCityVcViewController") as! AddyourCityVcViewController
                searcscreen.viewofMap = self.userMapView
                searcscreen.delegate = self
                self.navigationController?.pushViewController(searcscreen, animated: true)
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in }))
            
            present(alert, animated: true, completion: nil)
        }

   
    
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


    
    
    //doubletap gesture callout
    @objc func doubletaped(sender: UITapGestureRecognizer)
    {
        print("double tap gesture recognized")
        let touchPoint = sender.location(in: userMapView)
                        let coordinate = userMapView.convert(touchPoint, toCoordinateFrom: userMapView)
                        let annotation = MKPointAnnotation()
                        annotation.title = "B"
                        annotation.coordinate = coordinate
                        userMapView.addAnnotation(annotation)
    }
    
    
    
   /* //applay polygon
    func applayPolygon()
    {
        var cordinatepoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for i in 0..<arrayCity.count
        {
            cordinatepoints.append(arrayCity[i].placemark.coordinate)
        }
        
        let polygoon = MKPolygon(coordinates: cordinatepoints, count: cordinatepoints.count)
        self.addpolygon = polygoon
        userMapView.addOverlay(polygoon)
    }
    */
    
    
    
    
    //after touch for three times the directions will call by using this function
    override func touchesEnded(_ touchss: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touchss.first
        {
            if touch.tapCount == 1
            {
                let locationOfTouch = touch.location(in:  self.userMapView)
                let CoordinateofLocation = userMapView.convert(locationOfTouch, toCoordinateFrom: userMapView)
                
                for polygon in userMapView.overlays as! [MKPolygon]
                {
                    let rendering = MKPolygonRenderer(polygon: polygon)
                    let poininmap = MKMapPoint(CoordinateofLocation)
                    let pointForView = rendering.point(for: poininmap)
                    if polygon.containing(coordin: CoordinateofLocation)
                    {
                        print("It is inside the range ofdirection")
                        
                    }
                }
            }
        }
        super.touchesEnded(touchss, with: event)
    }
    
    
    
    func pointCheck(location : CLLocationCoordinate2D) {
        var arrDistance : [Double] = []
        for i in 0..<arrayCity.count
        {
            let dist = distanceGetting(source: location, destination: arrayCity[i].placemark.coordinate)
            arrDistance.append(dist)
        }
        let see = arrDistance.max { a, b in
            return a > b
        }
        var index = 0
        for i in 0..<arrDistance.count {
            if see == arrDistance[i] {
                index = i
                break
            }
        }
        arrayCity.remove(at: index)
        
        //userMapView.removeAnnotation
        userMapView.removeAnnotations(userMapView.annotations)
        if userMapView.overlays.last != nil {
            userMapView.removeOverlay(userMapView.overlays.last!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addAnnotations()
            self.checkforRouteOption()
        }
        
    }
    
    
    
    //calculating distance
    
    func distanceGetting(source : CLLocationCoordinate2D, destination : CLLocationCoordinate2D) ->  Double {
        let coordinate₀ = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let coordinate₁ = CLLocation(latitude: destination.latitude, longitude: destination.longitude)

        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        return Double(distanceInMeters)
    }

    
    
}


//creating diiferent extension for differnt usages.


//first create extenstion for viewControllar
extension ViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region  = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        userMapView.setRegion(region, animated: true)
        userMapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.title = "Current Location"
        userMapView.addAnnotation(annotation)
    }
    
    
    //this function will calculate how many touces happended.
    //if there has 3 pins than it will send the data for drawing triangle
    func addAnnotations()
    {
        var annotations = [MKAnnotation]()
        
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
                annotation.title = "C"
                insertingPolygon()
            }
            else
            {
                annotation.title = ""
            }
            annotation.coordinate = CLLocationCoordinate2D(latitude: arrayCity[i].placemark.coordinate.latitude, longitude: arrayCity[i].placemark.coordinate.longitude)
            annotations.append(annotation)
        }
        userMapView.addAnnotations(annotations)
        userMapView.addAllItems(in: annotations, andShow: true)
    }

}



//annother extension for "resultaftersearch" that is available inside another page
extension ViewController: resultaftersearch
{
    func viewListofCity(item: MKMapItem)
    {
        arrayCity.append(item)
        addAnnotations()
    }
        
    

}



//let's create another extension regarding mapViewDelegate

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if addpolygon == nil {
            let renderer = MKPolylineRenderer(overlay: overlay)
            if overlay.title == "A" {
                renderer.strokeColor = UIColor.blue
            } else if overlay.title == "B" {
                renderer.strokeColor = UIColor.red
            } else if overlay.title == "C" {
                renderer.strokeColor = UIColor.yellow
            }
            renderer.lineWidth = 4.0
            return renderer
        } else {
            let renderer = MKPolygonRenderer(polygon: addpolygon!)
            renderer.fillColor = UIColor.red.withAlphaComponent(0.50)
            return renderer
        }
    }
}



//another extension for MKPolygon
extension MKPolygon {
    func containing(coordin: CLLocationCoordinate2D) -> Bool {
        let polygonRenderer = MKPolygonRenderer(polygon: self)
        let currentMapPoint: MKMapPoint = MKMapPoint(coordin)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: currentMapPoint)
        if polygonRenderer.path == nil {
          return false
        }else{
          return polygonRenderer.path.contains(polygonViewPoint)
        }
    }
}


//another extension regarding mapview
//this will use for displaying all the annotations
extension MKMapView
{
    func addAllItems()
    {
        var zoom:MKMapRect = MKMapRect.null;
        for annotation in annotations
        {
            let poinforAnnotation = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: poinforAnnotation.x, y: poinforAnnotation.y, width: 2.0, height: 2.0);
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
            let rect = MKMapRect(x: annoPoint.x, y: annoPoint.y, width: 1.0, height: 1.0)
            
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



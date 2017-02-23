//
//  MapViewController.swift
//  TD5
//
//  Created by Jonathan on 20/02/2017.
//  Copyright © 2017 Ludivine. All rights reserved.
//

import UIKit
import MapKit
import SWXMLHash
import CoreLocation


struct Poi {
    var id: Int
    var name: String
    var image: String
    var latitude: Float
    var longitude: Float
    var description: String
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var pois = [Poi]()
    var mapView = MKMapView()
    var locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        createMapView()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true

        
        
        /*let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = view.frame.size.height-20
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        self.mapView.showsUserLocation = true*/
        
       
        
        if let url = URL(string: "http://dam.lanoosphere.com/poi.xml") {
            if let data = try? Data(contentsOf: url) {
                let xml = SWXMLHash.parse(data)
                for poi in xml["Data"]["POI"].all { // parser les POI
                    
                    let poi = Poi( // création d'un objet Poi
                        id: Int((poi.element?.attribute(by: "id")?.text)!)!,
                        name: (poi.element?.attribute(by: "name")?.text)!,
                        image: (poi.element?.attribute(by: "image")?.text)!,
                        latitude: Float((poi.element?.attribute(by: "latitude")?.text)!)!,
                        longitude: Float((poi.element?.attribute(by: "longitude")?.text)!)!,
                        description: (poi.element?.attribute(by: "description")?.text)!)
                    
                        print("test")
                        pois.append(poi)
                    
                
                }
            }
        
        // Do any additional setup after loading the view.
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        for poi in pois{
            print(poi.latitude)
            print(poi.longitude)
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(poi.latitude), longitude: CLLocationDegrees(poi.longitude))
            annotation.coordinate = centerCoordinate
            mapView.addAnnotation(annotation)
        }
        view.addSubview(mapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    func createMapView()
    {
        mapView = MKMapView()
        
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = view.frame.size.height-20
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 43.551534, longitude: 7.016659)
        
        // Or, if needed, we can position map in the center of the view
        //mapView.center = view.center
        
        view.addSubview(mapView)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        print(location)
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
            }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)" + error.localizedDescription)
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



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


public struct Poi {
    
    var id: Int! = nil
    var url: String! = nil
    var name: String! = nil
    var mail: String! = nil
    var image: String! = nil
    var phone: String! = nil
    var latitude: Float! = nil
    var longitude: Float! = nil
    var description: String! = nil
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var pois = [Poi]()
    var poisListString = [String]()
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        createMapView()
        navigationItem.title = "The MAP" // titre de la page
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        self.mapView.delegate = self // permet d'accéder à la méthode mapView
        
        // Cannes coordonnées
        let lat = 43.551534
        let long = 7.016659
        // zoom sur cannes
        let span = MKCoordinateSpanMake(0.060, 0.060)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        mapView.setRegion(region, animated: true)
        
        // chargement des données xml
        if let url = URL(string: "http://dam.lanoosphere.com/poi.xml") {
            if let data = try? Data(contentsOf: url) {
                let xml = SWXMLHash.parse(data)
                for poi in xml["Data"]["POI"].all { // parser les POI
                    
                    let poi = Poi( // création d'un objet Poi
                        id: Int((poi.element?.attribute(by: "id")?.text)!)!,
                        url: (poi.element?.attribute(by: "url")?.text)!,
                        name: (poi.element?.attribute(by: "name")?.text)!,
                        mail: (poi.element?.attribute(by: "description")?.text)!,
                        image: (poi.element?.attribute(by: "image")?.text)!,
                        phone: (poi.element?.attribute(by: "phone")?.text)!,
                        latitude: Float((poi.element?.attribute(by: "latitude")?.text)!)!,
                        longitude: Float((poi.element?.attribute(by: "longitude")?.text)!)!,
                        description: (poi.element?.attribute(by: "description")?.text)!)
                    
                        //print("test")
                        pois.append(poi)
                        poisListString.append(poi.name);
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for poi in pois{
            
            let annotation = MKPointAnnotation()
            // emplacement pin
            let centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(poi.latitude), longitude: CLLocationDegrees(poi.longitude))
            annotation.coordinate = centerCoordinate
            annotation.title = poi.name // ajout annotation titre
            
            // transformation lattitude longitude en localisation
            let mylocation = CLLocation(latitude: CLLocationDegrees(poi.latitude), longitude: CLLocationDegrees(poi.longitude))
            // transforme localisation en adresse
            CLGeocoder().reverseGeocodeLocation(mylocation, completionHandler: { (placemark, error) in
                if error != nil {
                    print("error")
                } else {
                    if let place = placemark?[0] {
                        // vérifie que adresse et numéro ne sont pas nil
                        if let address = place.thoroughfare, let num = place.subThoroughfare {
                            annotation.subtitle = num + " " + address + " " + place.postalCode! + " " + place.locality!
                        } else {
                            annotation.subtitle = place.postalCode! + " " + place.locality!
                        }
                    }
                }
            })
            mapView.addAnnotation(annotation)
        }
        view.addSubview(mapView)
    }
    
    // ajout du bouton
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tag = annotation.hash
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            
            return pinView
        }
        else {
            return nil
        }
    }
    
    // fonction click bouton info annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // instantie la vue détails
        let details = self.storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailsViewController
        
        //On récupère le poi
        let poi = getPin(title: (view.annotation?.title!)!)
        
        //Si le poi n'est pas vide
        if(poi.name != "") {
            
            //On envoie le poi à la vue
            details.poi = poi
        
        // push à la vue grace au controller
        self.navigationController?.pushViewController(details, animated: true)
        }
    }
    
    //Fonction permettant de récupérer un poi en fonction de son nom
    func getPin(title: String) -> Poi {
        
        var poi = Poi()
        
        //On regarde si le pin existe
        if(poisListString.contains(title)) {
            
            //On récupère l'indice du poi dans le tableau de string
            let indicePoi = (poisListString.index(of: title)!)
            
            //On récupère le poi
            poi = pois[indicePoi]
            
        } else {
            print("Poi inexistant");
        }
        
        return poi
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func createMapView()
    {
        
        mapView = MKMapView()
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        print(location)
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
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



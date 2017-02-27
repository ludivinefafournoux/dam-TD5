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
    var url: String
    var name: String
    var mail: String
    var image: String
    var phone: String
    var latitude: Float
    var longitude: Float
    var description: String
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var pois = [Poi]()
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var myActivityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Indicator.startAnimating()
        createMapView()
        navigationItem.title = "The MAP" // titre de la page
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true // permet d'accéder à la méthode mapView
        
        self.mapView.delegate = self
        
        // Cannes coordonnées
        let lat = 43.551534
        let long = 7.016659
        // zoom sur cannes
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        mapView.setRegion(region, animated: true)

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
                }
            }
        
        // Do any additional setup after loading the view.
        }
        
    }
    
    @IBOutlet weak var Indicator: UIActivityIndicatorView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for poi in pois{
            //print(poi.latitude)
            //print(poi.longitude)
            let annotation = CustomPointAnnotation()
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
            
            annotation.id = poi.id
            
            //annotation.subtitle = poi.description
            mapView.addAnnotation(annotation)
        }
        view.addSubview(mapView)
    }
    
    // ajout du bouton
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //print("la")
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
        
        // défini et renseigne les variables de mywebviewcontroller à passer à la vue
        //details.strPhoneNumber = pois.index(after: CustomPointAnnotation.id)
        /*web.descrElement = categories[indexPath.section].elements[indexPath.row].descr
        web.image = categories[indexPath.section].elements[indexPath.row].image_large
        */
        // push à la webview grace au controller
        self.navigationController?.pushViewController(details, animated: true)
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



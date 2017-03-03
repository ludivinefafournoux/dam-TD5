//
//  DetailsViewController.swift
//  TD5
//
//  Created by Laura Daufeld on 26/02/2017.
//  Copyright © 2017 Ludivine. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class DetailsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var map: MKMapView!
    var strPhoneNumber = ""
    var imageUrl = ""
    var titre = ""
    var poi = Poi()
    let locationManager = CLLocationManager()
    
    
    
    // fonction bouton call (ne fonctionne pas avec simulateur)
    @IBAction func call(_ sender: Any) {
        
        strPhoneNumber = poi.phone
        
        // transforme numéro au bon format
        let index = strPhoneNumber.index(strPhoneNumber.startIndex, offsetBy: 7) // supprime le début
        strPhoneNumber = "0" + strPhoneNumber.substring(from: index) // rajoute un 0
        strPhoneNumber = strPhoneNumber.replacingOccurrences(of: " ", with: "") // supprime les espaces
        print(strPhoneNumber)
        
        if let phoneCallURL:URL = URL(string: "tel:\(strPhoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "Appel", message: "Êtes-vous sûr de vouloir appeler \n\(self.strPhoneNumber)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    application.openURL(phoneCallURL)
                })
                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // fonction ouvrir dans Plan
    @IBAction func openMap(_ sender: Any) {
        
        
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(poi.latitude), CLLocationDegrees(poi.longitude))
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = poi.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    // fonction bouton share
    @IBAction func share(_ sender: Any) {
        // text to share
        let text = poi.description
        // image to share
        let image = URL(string: poi.image)
        
        let activityViewController = UIActivityViewController(activityItems: [text, image],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        navigationItem.title = poi.name // titre de la page

        
        // chargement de l'image asynchrone avec SDWebImage
        image.sd_setImage(with: URL(string: poi.image), placeholderImage: UIImage(named: "image"))
        
        map.delegate = self
        
        // 2.
        let sourceLocation = CLLocationCoordinate2D(latitude: (CLLocationDegrees((locationManager.location?.coordinate.latitude)!)), longitude: (CLLocationDegrees((locationManager.location?.coordinate.longitude)!)))
        let destinationLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(poi.latitude), longitude: CLLocationDegrees(poi.longitude))
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapPoi = MKMapItem(placemark: sourcePlacemark)
        let destinationMapPoi = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = poi.name
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapPoi
        directionRequest.destination = destinationMapPoi
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.map.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }

        // Do any additional setup after loading the view.
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        let blue = UIColor.blue
        renderer.strokeColor = blue.withAlphaComponent(0.5)
        renderer.lineWidth = 5.0
        
        return renderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //print("la")
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tag = annotation.hash
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            pinView.pinTintColor = .green
            
            return pinView
        }
        else {
            return nil
        }
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

//
//  CustomPointAnnotation.swift
//  TD5
//
//  Created by Laura Daufeld on 27/02/2017.
//  Copyright © 2017 Ludivine. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: NSObject, MKAnnotation
{

    var id = 0
    var identifier = ""
    var title: String? = ""
    var subtitle: String? = ""
    var coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(43.551534), longitude: CLLocationDegrees(7.016659))
    //var color: MKPinAnnotationColor
    
    
    /*init(identifier: String, title: String, subtitle: String, coordinate: CLLocationCoordinate2D, color: MKPinAnnotationColor)
    {
        self.identifier = identifier
        self.titre = title
        self.soustitre = subtitle
        self.coordinate = coordinate
        self.color = color
        
        super.init()
    }*/
    
    /*override init()
     {
     
        super.init()
     }*/
    
    /*func mapItem() -> MKMapItem
    {
        let addressDictionary = [String(kABPersonAddressStreetKey): soustitre]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = titre
        
        return mapItem
    }*/
}

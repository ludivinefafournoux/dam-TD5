//
//  ViewController.swift
//  TD5
//
//  Created by Jonathan on 20/02/2017.
//  Copyright © 2017 Ludivine. All rights reserved.
//

import UIKit
import SWXMLHash


class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "http://dam.lanoosphere.com/poi.xml") {
            if let data = try? Data(contentsOf: url) {
                let xml = SWXMLHash.parse(data)
                for poi in xml["data"]["script"] { // parser les POI
                    
                    print(poi["POI"].element?.attribute(by: "name")?.text)
                    print("test")
                    /*var tmpElement = [Element]()
                    var category = Category( // création d'un objet catégorie
                        id: Int((cat.element?.attribute(by: "id")?.text)!)!,
                        name: (cat.element?.attribute(by: "name")?.text)!,
                        elements: tmpElement)
                    
                    
                    for elem in cat["element"] { // parser les éléments
                        let element = Element( // création d'un objet element
                            id: Int((elem.element?.attribute(by: "id")?.text)!)!,
                            img: (elem.element?.attribute(by: "image")?.text)!,
                            name: (elem.element?.attribute(by: "name")?.text)!,
                            id_category: Int((elem.element?.attribute(by: "category_id")?.text)!)!,
                            image_large: (elem.element?.attribute(by: "image_large")?.text)!,
                            descr: (elem.element?.attribute(by: "descr")?.text)!)
                        
                        tmpElement.append(element) // ajoute l'objet element au tableau d'éléments
                    }
                    
                    category.elements = tmpElement
                    categories.append(category) // ajoute l'objet category au tableau de catégories*/
                }
            }
        }
    

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


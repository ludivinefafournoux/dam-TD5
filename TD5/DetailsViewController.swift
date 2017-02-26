//
//  DetailsViewController.swift
//  TD5
//
//  Created by Laura Daufeld on 26/02/2017.
//  Copyright © 2017 Ludivine. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var map: MKMapView!
    let strPhoneNumber = ""
    
    // fonction bouton call (ne fonctionne pas avec simulateur)
    @IBAction func call(_ sender: Any) {
        if let phoneCallURL:URL = URL(string: "tel:\(strPhoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "Call", message: "Are you sure you want to call \n\(self.strPhoneNumber)?", preferredStyle: .alert)
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
    
    @IBAction func openMap(_ sender: Any) {
    }
    
    // fonction bouton share
    @IBAction func share(_ sender: Any) {
        // text to share
        let text = "This is some text that I want to share."
        // image to share
        let image = UIImage(named: "Image")
        
        let activityViewController = UIActivityViewController(activityItems: [text, image],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

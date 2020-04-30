//
//  ViewController.swift
//  MapApp
//
//  Created by Cristian Sedano Arenas on 29/04/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    @IBAction func centerMapButtonWasPressed(_ sender: UIButton) {
        
    }
    
}

extension MapVC : MKMapViewDelegate {
    
}

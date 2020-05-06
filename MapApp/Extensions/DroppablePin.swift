//
//  DroppablePen.swift
//  MapApp
//
//  Created by Cristian Sedano Arenas on 01/05/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin : NSObject, MKAnnotation {
    
    dynamic var coordinate : CLLocationCoordinate2D
    var identifier : String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}

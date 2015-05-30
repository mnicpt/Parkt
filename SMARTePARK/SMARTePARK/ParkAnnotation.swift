//
//  ParkAnnotation.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/30/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import MapKit

class ParkAnnotation: NSObject, MKAnnotation {

    // overridden properties
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    // custom properties
    var id: String
    var distance: String
    var cost: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        self.id = ""
        self.distance = ""
        self.cost = ""
        
        super.init()
    }
}

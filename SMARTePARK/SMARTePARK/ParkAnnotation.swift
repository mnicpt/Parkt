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
    var id: Int
    var name: String
    var street: String
    var distance: Int
    var cost: String
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = ""
        self.subtitle = ""
        self.id = 0
        self.name = ""
        self.street = ""
        self.distance = 0
        self.cost = ""
        
        super.init()
    }
}

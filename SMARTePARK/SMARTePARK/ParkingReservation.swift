//
//  ParkingReservation.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/30/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import Foundation
import MapKit

class ParkingReservation {
    
    var id: String
    var location: CLLocation
    var name: String
    var street: String
    var city: String
    var state: String
    var zip: String
    var start: NSDate
    var end: NSDate
    var price: String
    var vehicle: Vehicle
    
    init(id: String, location: CLLocation, name: String, street: String, city: String, state: String, zip: String, start: NSDate, end: NSDate, price: String, vehicle: Vehicle) {
        self.id = id
        self.location = location
        self.name = name
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.start = start
        self.end = end
        self.price = price
        self.vehicle = vehicle
    }
}
//
//  Vehicle.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/30/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import Foundation

class Vehicle {
    
    var year: String
    var make: String
    var model: String
    var bodyStyle: String
    var vin: String
    var license: String
    
    init(year: String, make: String, model: String, bodyStyle: String, vin: String, license: String) {
        self.year = year
        self.make = make
        self.model = model
        self.bodyStyle = bodyStyle
        self.vin = vin
        self.license = license
    }
}
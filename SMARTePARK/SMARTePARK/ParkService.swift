//
//  ParkService.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/22/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import Foundation
import CoreLocation

let PARKING_FOUND: String = "ParkingFound"
let NO_PARKING_FOUND: String = "NoParkingFound"

class ParkService {
    
    private static let apiKey: String = "237dcc7388ef005312c2077db47ce2f0"
    private static var baseAddressUrl: String = "http://api.parkwhiz.com/search/?"

    class func fetchParkingNow(location: CLLocation) {
        let timestamp = NSDate().timeIntervalSince1970
        
        let url = NSURL(
            string: buildParkNowUrl(
                lat: Float(location.coordinate.latitude),
                lng: Float(location.coordinate.longitude),
                start: Int(timestamp),
                end: Int(timestamp + 3600)))
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 300)
        
        var locations: NSDictionary?
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            var err: NSError?
            if data.length > 0 && error == nil {
                locations = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
                
                if locations?.objectForKey("locations") as? Int > 0 && error == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(PARKING_FOUND, object: nil, userInfo: locations! as [NSObject : AnyObject])
                } else {
                    NSNotificationCenter.defaultCenter().postNotificationName(NO_PARKING_FOUND, object: nil, userInfo: ["error" : "No parking found nearby.", "location" : CLLocationManager().location])
                }
            }
        }
    }
    
    class func fetchParkingByLocation(location: String) {
        let timestamp = NSDate().timeIntervalSince1970
        
        let url = NSURL(
            string: buildParkLaterUrl(
                location,
                start: Int(timestamp),
                end: Int(timestamp + 3600)))
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 300)
        
        var locations: NSDictionary?
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            var err: NSError?
            if data.length > 0 && error == nil {
                locations = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
                
                if locations?.objectForKey("locations") as? Int > 0 && error == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(PARKING_FOUND, object: nil, userInfo: locations! as [NSObject : AnyObject])
                } else {
                    if let errorMsg = locations?.objectForKey("error") as? String {

                    } else {
                        let location = CLLocation(latitude: locations?.objectForKey("lat") as! CLLocationDegrees, longitude: locations?.objectForKey("lng") as! CLLocationDegrees)
                        NSNotificationCenter.defaultCenter().postNotificationName(NO_PARKING_FOUND, object: nil, userInfo: ["error" : "No parking found nearby.", "location" : location])
                    }
                }
            }
        }
    }

    // MARK: - Private helper methods
    private class func buildParkNowUrl(lat latitude: Float, lng: Float, start: Int, end: Int) -> String {
        
        return  baseAddressUrl +
                "key=\(apiKey)" +
                "&lat=\(latitude)" +
                "&lng=\(lng)" +
                "&start=\(start)" +
                "&end=\(end)"
            
    }
    
    private class func buildParkLaterUrl(destination: String, start: Int, end: Int) -> String {
        let formattedDestination = destination.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        return  baseAddressUrl +
            "key=\(apiKey)" +
            "&destination=\(formattedDestination)" +
            "&start=\(start)" +
            "&end=\(end)"
    }
}
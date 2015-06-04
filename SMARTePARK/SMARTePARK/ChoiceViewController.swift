//
//  ChoiceViewController.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/20/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import UIKit
import MapKit

class ChoiceViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var parkingInformationView: UIVisualEffectView!
    
    @IBOutlet var parkingName: UILabel!
    @IBOutlet var parkingAddress: UILabel!
    @IBOutlet var parkingDistance: UILabel!
    @IBOutlet var parkingAmount: UIButton!
    @IBOutlet var parkingStart: UILabel!
    @IBOutlet var parkingEnd: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "parkingFound:", name: PARKING_FOUND, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noParkingFound:", name: NO_PARKING_FOUND, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        parkingStart.text = AppDelegate.formatDate(AppDelegate.currentReservation().objectForKey("start") as! NSDate)
        parkingEnd.text = AppDelegate.formatDate(AppDelegate.currentReservation().objectForKey("end") as! NSDate)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)

        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // memory release of tiles trick
        switch (mapView.mapType) {
        case MKMapType.Standard:
            mapView.mapType = MKMapType.Hybrid
            mapView.mapType = MKMapType.Standard
        case MKMapType.Hybrid:
            mapView.mapType = MKMapType.Standard
            mapView.mapType = MKMapType.Hybrid
        default:
            mapView.mapType = MKMapType.Standard
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Notifications
    func parkingFound(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let locations = userInfo.objectForKey("parking_listings") as? NSArray
        
        let location = CLLocation(latitude: userInfo.objectForKey("lat") as! CLLocationDegrees, longitude: userInfo.objectForKey("lng") as! CLLocationDegrees)
        let radius: CLLocationDistance = (userInfo.objectForKey("max_distance") as! Double / 2.0)
        
        setVisibleArea(location, radius: radius)
        
        //update map with locations
        NSLog("Locations: %@", locations!)
        
        for listing in locations! {
            
            var annotation = ParkAnnotation()
            annotation.id = listing.objectForKey("location_id") as! Int
            annotation.name = listing.objectForKey("location_name") as! String
            annotation.coordinate.latitude = listing.objectForKey("lat") as! CLLocationDegrees
            annotation.coordinate.longitude = listing.objectForKey("lng") as! CLLocationDegrees
            annotation.title = listing.objectForKey("price_formatted") as! String
            annotation.cost = listing.objectForKey("price_formatted") as! String
            annotation.distance = listing.objectForKey("distance") as! Int
            annotation.street = listing.objectForKey("address") as! String

            mapView.addAnnotation( annotation )
            
            if locations?.firstObject === listing {
                mapView.selectAnnotation(annotation, animated: true)
                
                parkingName.text = annotation.name
            }
        }
        
        parkingInformationView.hidden = false
    }
    
    func noParkingFound(notification: NSNotification) {
        var alert = UIAlertController(title: "No Parking Found", message: "Search again?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        parkingName.text = (view.annotation as! ParkAnnotation).name
        parkingAddress.text = (view.annotation as! ParkAnnotation).street
        
        let distanceInMiles = Float((view.annotation as! ParkAnnotation).distance) * 0.000189394
        let distance = NSNumberFormatter.localizedStringFromNumber(distanceInMiles, numberStyle: NSNumberFormatterStyle.DecimalStyle)
        

        parkingDistance.text = distance + " miles"
        
        AppDelegate.updateCurrentReservation("name", withValue: (view.annotation as! ParkAnnotation).name)
        AppDelegate.updateCurrentReservation("street", withValue: (view.annotation as! ParkAnnotation).street)
        AppDelegate.updateCurrentReservation("distance", withValue: distance + " miles")
    }
    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "parkAnnotationView")
//        annotationView.backgroundColor = UIColor(red: 75/255, green: 182/255, blue: 33/255, alpha: 1)
//        annotationView.tintColor = UIColor.whiteColor()
//        
//        return annotationView
//    }
    
    // MARK: - Actions
    @IBAction func startOver(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Private
    private func centerMapOnLocation(location: CLLocation, withRadius radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            radius * 2.0, radius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func setVisibleArea(location: CLLocation, radius: CLLocationDistance) {
        // set visible area
        centerMapOnLocation(location, withRadius: radius)
    }
    
}

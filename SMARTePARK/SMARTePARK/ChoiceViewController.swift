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
    @IBOutlet var parkingName: UILabel!
    @IBOutlet var parkingAddress: UILabel!
    @IBOutlet var parkingDistance: UILabel!
    @IBOutlet var parkingAmount: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "parkingFound:", name: PARKING_FOUND, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noParkingFound:", name: NO_PARKING_FOUND, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        parkingName.hidden = false
        parkingAmount.hidden = false
        parkingAddress.hidden = false
        parkingDistance.hidden = false
    }

    override func viewWillDisappear(animated: Bool) {
        // memory release of tiles trick
        switch mapView.mapType {
            case MKMapType.Standard:
                mapView.mapType = MKMapType.Hybrid
                mapView.mapType = MKMapType.Standard
            case MKMapType.Hybrid:
                mapView.mapType = MKMapType.Standard
                mapView.mapType = MKMapType.Hybrid
            default:
                mapView.mapType = MKMapType.Standard
        }
        
        mapView.removeFromSuperview()
        mapView.delegate = nil
        mapView = nil
        
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
            
            var annotation = MKPointAnnotation()
            annotation.coordinate.latitude = listing.objectForKey("lat") as! CLLocationDegrees
            annotation.coordinate.longitude = listing.objectForKey("lng") as! CLLocationDegrees
            annotation.title = listing.objectForKey("price_formatted") as! String
            annotation.subtitle = listing.objectForKey("location_name") as! String

            mapView.addAnnotation( annotation )
            
            if locations?.firstObject === listing {
                mapView.selectAnnotation(annotation, animated: true)
                
                parkingName.text = annotation.subtitle
                parkingAmount.setTitle(annotation.title, forState: .Normal)
            }
        }
    }
    
    func noParkingFound(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let errorMsg = userInfo.objectForKey("error") as! String
        
        if let location = userInfo.objectForKey("location") as? CLLocation {
            setVisibleArea(location, radius: 2000)
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
        parkingName.text = errorMsg
        parkingAmount.hidden = true
        parkingAddress.hidden = true
        parkingDistance.hidden = true
    }

    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        parkingName.text = view.annotation.subtitle
        parkingAmount.setTitle(view.annotation.title, forState: .Normal)
    }
    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "parkAnnotationView")
//        let image = UIImage(named: "logo")
//        annotationView.image = image
//        
//        return annotationView
//    }
    
    // MARK: - Actions
    @IBAction func startOver(sender: AnyObject) {
        let coverViewController = storyboard?.instantiateViewControllerWithIdentifier( "CoverViewController" ) as! CoverVIewController
        presentViewController(coverViewController, animated: true, completion: nil)
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

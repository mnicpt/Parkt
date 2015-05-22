//
//  ChoiceViewController.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/20/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import UIKit
import MapKit

class ChoiceViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(animated: Bool) {
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
        
        mapView.removeFromSuperview()
        mapView = nil
        
        locationManager.stopUpdatingLocation()
        
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
    

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions
    @IBAction func startOver(sender: AnyObject) {
        let coverViewController = storyboard?.instantiateViewControllerWithIdentifier( "CoverViewController" ) as! CoverVIewController
        presentViewController(coverViewController, animated: true, completion: nil)
    }
    
}

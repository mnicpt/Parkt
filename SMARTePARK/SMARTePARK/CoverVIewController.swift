//
//  CoverVIewController.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/20/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import UIKit
import MapKit

class CoverVIewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet var logo: UIImageView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var parkingDatePicker: UIDatePicker!
    @IBOutlet var parkingDate: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parkingDatePicker.frame.size = CGSize(width: view.bounds.size.width, height: 0)
        
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 30
        logo.layer.opacity = 0.75
        
        locationManager.delegate = self
        locationTextField.delegate = self
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        
        super.viewDidDisappear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        parkingDate.setTitle(formatDate(NSDate()), forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    @IBAction func dateSelected(sender: UIButton) {
        parkingDatePicker.hidden = !parkingDatePicker.hidden
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        parkingDate.setTitle(formatDate(sender.date), forState: .Normal)
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        searchBtn.setTitle("Search", forState: .Normal)
    }
    
    // MARK: - Seque
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if CLLocationManager.locationServicesEnabled() {
            if locationTextField.text.isEmpty {
                ParkService.fetchParkingNow(locationManager.location)
            } else {
                ParkService.fetchParkingByLocation(locationTextField.text)
            }
        }
    }

    // MARK: - Private
    private func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(date)
    }
}

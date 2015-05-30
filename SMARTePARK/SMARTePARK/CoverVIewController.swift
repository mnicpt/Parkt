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
    @IBOutlet var parkingTimeLabel: UILabel!
    @IBOutlet var leavingDatePicker: UIDatePicker!
    @IBOutlet var leavingDate: UIButton!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        locationTextField.text = AppDelegate.currentReservation().objectForKey("search") as! String
        parkingDate.setTitle(formatDate(AppDelegate.currentReservation().objectForKey("start") as! NSDate), forState: .Normal)
        parkingDatePicker.date = AppDelegate.currentReservation().objectForKey("start") as! NSDate
        leavingDate.setTitle(formatDate(AppDelegate.currentReservation().objectForKey("end") as! NSDate), forState: .Normal)
        leavingDatePicker.date = AppDelegate.currentReservation().objectForKey("end") as! NSDate
        
        if locationTextField.text.isEmpty {
            searchBtn.setTitle("Park Now", forState: .Normal)
            leavingDate.setTitle("", forState: .Normal)
            leavingDatePicker.date = NSDate()
        } else {
            searchBtn.setTitle("Search", forState: .Normal)
        }
    }

    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        
        super.viewDidDisappear(animated)
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
        leavingDatePicker.hidden = true
        parkingDatePicker.hidden = !parkingDatePicker.hidden
        
        if parkingDatePicker.hidden {
            parkingTimeLabel.hidden = false
            leavingDate.hidden = false
            searchBtn.hidden = false
            
        } else {
            parkingTimeLabel.hidden = true
            leavingDate.hidden = true
            searchBtn.hidden = true
        }
    }
    
    @IBAction func leavingDateSelected(sender: UIButton) {
        searchBtn.setTitle("Search", forState: .Normal)
        
        parkingDatePicker.hidden = true
        leavingDatePicker.hidden = !leavingDatePicker.hidden
        
        if leavingDatePicker.hidden {
            searchBtn.hidden = false
        } else {
            searchBtn.hidden = true
        }
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        parkingDate.setTitle(formatDate(sender.date), forState: .Normal)
        
        AppDelegate.updateCurrentReservation("start", withValue: sender.date)
    }
    
    @IBAction func leavingDateChanged(sender: UIDatePicker) {
        leavingDate.setTitle(formatDate(sender.date), forState: .Normal)
        
        AppDelegate.updateCurrentReservation("end", withValue: sender.date)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        AppDelegate.updateCurrentReservation("search", withValue: textField.text)
        
        return true
    }
    
    // MARK: - Seque
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if CLLocationManager.locationServicesEnabled() {
            if locationTextField.text.isEmpty {
                ParkService.fetchParkingNow(locationManager.location)
            } else {
                var endDate: NSDate?
                
                if (leavingDate.titleLabel?.text == "") {
                    endDate = NSCalendar.currentCalendar().dateByAddingUnit(
                        NSCalendarUnit.CalendarUnitHour,
                        value: 1,
                        toDate: NSDate(),
                        options: NSCalendarOptions.WrapComponents)
                }
                
                ParkService.fetchParkingByLocation(locationTextField.text, startDate: parkingDatePicker.date, endDate: endDate == nil ? leavingDatePicker.date : endDate!)
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

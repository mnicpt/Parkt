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
    @IBOutlet var parkNowBtn: UIButton!
    @IBOutlet var parkLaterBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var leaseSpotBtn: UIButton!
    @IBOutlet var parkingDatePicker: UIDatePicker!
    @IBOutlet var parkingDate: UIButton!
    @IBOutlet var leavingDatePicker: UIDatePicker!
    @IBOutlet var leavingDate: UIButton!
    @IBOutlet var parkingDateLabel: UILabel!
    @IBOutlet var leavingDateLabel: UILabel!
    @IBOutlet var orLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nearView = UILabel(frame: CGRect(x: 0, y: 5, width: 50, height: 15))
        nearView.textColor = UIColor(white: 0.4, alpha: 1.0)
        nearView.text = " Near: "
        
        locationTextField.leftViewMode = UITextFieldViewMode.Always
        locationTextField.leftView = nearView
        
        initView()
        
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
        
        initView()
        
        locationTextField.text = AppDelegate.currentReservation().objectForKey("search") as! String
        parkingDate.setTitle(AppDelegate.formatDate(AppDelegate.currentReservation().objectForKey("start") as! NSDate), forState: .Normal)
        parkingDatePicker.date = AppDelegate.currentReservation().objectForKey("start") as! NSDate
        leavingDate.setTitle(AppDelegate.formatDate(AppDelegate.currentReservation().objectForKey("end") as! NSDate), forState: .Normal)
        leavingDatePicker.date = AppDelegate.currentReservation().objectForKey("end") as! NSDate
        
        if locationTextField.text.isEmpty {
            leavingDate.setTitle("Edit", forState: .Normal)
            leavingDatePicker.date = NSDate()
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
            parkingDate.hidden = false
            leavingDate.hidden = false
            leavingDateLabel.hidden = false
            searchBtn.hidden = false
        } else {
            parkingDate.hidden = false
            leavingDate.hidden = true
            leavingDateLabel.hidden = true
            searchBtn.hidden = true
        }
    }
    
    @IBAction func leavingDateSelected(sender: UIButton) {
        parkingDatePicker.hidden = true
        leavingDatePicker.hidden = !leavingDatePicker.hidden
        
        if leavingDatePicker.hidden {
            searchBtn.hidden = false
        } else {
            searchBtn.hidden = true
        }
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        parkingDate.setTitle(AppDelegate.formatDate(sender.date), forState: .Normal)
        
        AppDelegate.updateCurrentReservation("start", withValue: sender.date)
    }
    
    @IBAction func leavingDateChanged(sender: UIDatePicker) {
        leavingDate.setTitle(AppDelegate.formatDate(sender.date), forState: .Normal)
        
        AppDelegate.updateCurrentReservation("end", withValue: sender.date)
    }
    
    @IBAction func parkLater(sender: AnyObject) {
        parkNowBtn.hidden = true
        parkLaterBtn.hidden = true
        searchBtn.hidden = false
        leaseSpotBtn.hidden = true
        
        orLabel.hidden = true
        
        locationTextField.hidden = false
        parkingDate.hidden = false
        parkingDateLabel.hidden = false
        leavingDate.hidden = false
        leavingDateLabel.hidden = false
    }
    
    @IBAction func leaseMySpot(sender: AnyObject) {
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // show previous reservations
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        
        if textField.text != "" {
            AppDelegate.updateCurrentReservation("search", withValue: textField.text)
        }
        
        return true
    }
    
    // MARK: - Seque
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if CLLocationManager.locationServicesEnabled() {
            if locationTextField.text.isEmpty {
                ParkService.fetchParkingNow(locationManager.location)
            } else {
                var endDate: NSDate?
                
                if (leavingDate.titleLabel?.text == "Edit") {
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
    private func initView() {
        locationTextField.hidden = true
        parkingDateLabel.hidden = true
        leavingDateLabel.hidden = true
        parkingDate.hidden = true
        leavingDate.hidden = true
        searchBtn.hidden = true
        parkNowBtn.hidden = false
        parkLaterBtn.hidden = false
        leaseSpotBtn.hidden = false
        orLabel.hidden = false
    }
    
    private func initParkLaterView() {
        locationTextField.hidden = false
        parkingDateLabel.hidden = false
        leavingDateLabel.hidden = false
        parkingDate.hidden = false
        leavingDate.hidden = false
        searchBtn.hidden = false
        parkNowBtn.hidden = true
        parkLaterBtn.hidden = true
        leaseSpotBtn.hidden = true
        orLabel.hidden = true
    }
}

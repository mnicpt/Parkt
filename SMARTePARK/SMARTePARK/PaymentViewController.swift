//
//  PaymentViewController.swift
//  SMARTePARK
//
//  Created by Steven Mask on 6/1/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import UIKit
import MapKit

class PaymentViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
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
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let paymentCell = UITableViewCell(style: .Value1, reuseIdentifier: "PaymentCell")
        paymentCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if indexPath.row == 0  {
            paymentCell.textLabel?.text = "Vehicle"
            paymentCell.detailTextLabel?.text = "2015 Porsche Macan S"
        } else {
            paymentCell.textLabel?.text = "Payment"
            paymentCell.detailTextLabel?.text = " Pay"
        }
        
        return paymentCell
    }

    // MARK: - Actions
    @IBAction func findParking(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

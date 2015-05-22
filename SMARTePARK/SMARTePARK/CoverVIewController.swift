//
//  CoverVIewController.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/20/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import UIKit
import MapKit

class CoverVIewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var logo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 50
        logo.layer.opacity = 0.75

    }

    override func viewDidDisappear(animated: Bool) {
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
    
    //MARK: - Actions
    

}

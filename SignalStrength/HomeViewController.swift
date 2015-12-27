//
//  ViewController.swift
//  Location
//
//  Created by Henrique do Prado Linhares on 09/10/15.
//  Copyright © 2015 Henrique do Prado Linhares. All rights reserved.
//

import UIKit
import MapKit

/*
ViewController that controls the home screen
*/
class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var recordLocationSwitch: UISwitch!
    @IBOutlet weak var recordLocationStatusView: UIView!
    
    @IBOutlet weak var authorizationStatusLabel: UILabel!
    @IBOutlet weak var authorizationStatusView: UIView!
    
    var updateTimer = NSTimer()
    
    override func viewWillAppear(animated: Bool) {
        self.recordLocationSwitch.on = AppData.sharedInstance.getIsCurrentlyReading()
        self.update()
        self.centerMapOnUser()
        self.mapView.removeAnnotations(self.mapView.annotations)
        for r:Read in AppData.sharedInstance.getReads() {
            let pin = MKPointAnnotation()
            pin.title = SignalQuality.signalQualityToString(r.signalStrength.signalQuality)
            pin.coordinate.latitude = r.latitude
            pin.coordinate.longitude = r.longitude
            mapView.addAnnotation(pin)
        }
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.updateTimer.invalidate()
    }
    
    func centerMapOnUser(){
        let lastUserLocation = Location.sharedInstance.getLastUserLocation()
        if ((lastUserLocation) != nil){
            let lastUserLocationCoord2d = CLLocationCoordinate2D(latitude: (lastUserLocation?.coordinate.latitude)!, longitude: (lastUserLocation?.coordinate.longitude)!)
            self.mapView.setCenterCoordinate(lastUserLocationCoord2d, animated: true)
        }
    }
    
    func update(){
        if (Location.sharedInstance.doesHaveFullCLAuthorization()){
            self.authorizationStatusLabel.text = "Authorized"
            self.authorizationStatusView.backgroundColor = AppColors.myGreenColor
        } else {
            self.authorizationStatusLabel.text = "Not Authorized"
            self.authorizationStatusView.backgroundColor = AppColors.myRedColor
        }
        
        if (AppData.sharedInstance.getIsCurrentlyReading()){
            self.recordLocationStatusView.backgroundColor = AppColors.myGreenColor
        } else {
            self.recordLocationStatusView.backgroundColor = AppColors.myRedColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        AppData.sharedInstance.changeIsCurrentlyReadingStatus()
        if (AppData.sharedInstance.getIsCurrentlyReading()){
            Location.sharedInstance.startReading()
        } else {
            Location.sharedInstance.stopReading()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let alert = UIAlertController(title: "Memory Warning!", message: "From HomeViewController", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
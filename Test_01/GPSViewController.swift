//
//  GPSViewController.swift
//  Test_01
//
//  Created by Jithin Paul on 2017-12-10.
//  Copyright © 2017 Jithin Paul. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import CoreLocation

class GPSViewController: UIViewController,CLLocationManagerDelegate {
    var dbRef : DatabaseReference?
    var locationManager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("/users")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getLocationClick(_ sender: UIButton) {
        getDeviceLocation()
    }
    
    func getDeviceLocation(){
        locationManager = CLLocationManager()
        locationManager!.delegate = self;
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let newLocation:String = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        print(newLocation);
        self.dbRef?.child("\(Auth.auth().currentUser!.uid)/gps").setValue(newLocation)
        /*
        dbRef?.child("\(Auth.auth().currentUser!.uid)/gps").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let oldLocation = snapshot.value as? String{
                if(old)
                
            }
            
        })
         */
    }
    
}

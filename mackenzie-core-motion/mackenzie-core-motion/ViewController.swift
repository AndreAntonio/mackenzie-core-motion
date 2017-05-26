//
//  ViewController.swift
//  mackenzie-core-motion
//
//  Created by Andre Faruolo on 25/05/17.
//  Copyright © 2017 Andre Faruolo. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    var inside = false
    var piscina = false
    
    @IBOutlet weak var localOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.startUpdatingHeading()
            self.locationManager.startUpdatingLocation()
            
            if self.motionManager.isDeviceMotionAvailable {
                self.motionManager.deviceMotionUpdateInterval = 0.1
                self.motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: OperationQueue.main, withHandler: { (data, error) in
                    if error != nil {
                        print("vish, fudeu, tá dando erro no device motion")
                    } else {
                        if let _ = data {
                            if self.degreesParser((data?.attitude.pitch)!) < 1.0 && self.inside{
                                self.piscina = true
                                self.localOutlet.text = "Piscina"
                            } else {
                                self.piscina = false
                            }
                        }
                    }
                })
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.trueHeading)
        if self.inside && !self.piscina{
            switch newHeading.trueHeading {
            case 0..<105:
                self.localOutlet.text = "Maria Antônia"
            case 105..<197:
                self.localOutlet.text = "Consolação"
            case 271..<350:
                self.localOutlet.text = "Itambé"
            case 350..<360:
                self.localOutlet.text = "Maria Antônia"
            default:
                self.localOutlet.text = "Piauí"
            }
        } else {
            self.localOutlet.text = "Nenhum lugar"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let eu = self.locationManager.location ?? CLLocation()
        let borges = CLLocation(latitude: CLLocationDegrees(-23.547097), longitude: CLLocationDegrees(-46.651875))
        if eu.distance(from: borges) <= 100 {
            self.inside = true
        } else {
            self.inside = false
        }
    }
    
    func degreesParser(_ degree: Double) -> Double {
        let temp = degree * 180 / Double.pi
        if temp < 0 {
            return 360 + temp
        } else {
            return temp
        }
    }
}

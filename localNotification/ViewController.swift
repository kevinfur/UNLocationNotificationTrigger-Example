//
//  ViewController.swift
//  localNotification
//
//  Created by Kevin Alan Furman on 10/11/16.
//  Copyright © 2016 Kevin Alan Furman. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // less batery ussage
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("NotificationCenter Authorization Granted!")
            }
        }
        locationManager.startUpdatingLocation()
    }

    @IBAction func ScheduleNotification(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests() // deletes pending scheduled notifications, there is a schedule limit qty
        
        let content = UNMutableNotificationContent()
        content.title = "What are you doing here!?"
        content.body = "Run! This zone is dangerous! :o"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        
        // Ex. Trigger within a timeInterval
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Ex. Trigger within a Location
        let centerLoc = CLLocationCoordinate2D(latitude: 37.32975796, longitude: -122.01989151)
        let region = CLCircularRegion(center: centerLoc, radius: 100.0, identifier: UUID().uuidString) // radius in meters
        region.notifyOnEntry = true
        region.notifyOnExit = true
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        let latitude = String(latestLocation.coordinate.latitude)
        let longitude = String(latestLocation.coordinate.longitude)
        print("\(latitude) \(longitude)")
    }
    
}


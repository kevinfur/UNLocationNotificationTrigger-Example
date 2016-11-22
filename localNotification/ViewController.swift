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

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // para gastar menos bateria
        //locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    @IBAction func RegisterNotification(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }

    @IBAction func ScheduleNotification(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests() // borra las notificaciones locales pendientes, hay un limite
        
        let content = UNMutableNotificationContent()
        content.title = "Qué haces acá pibe!?"
        content.body = "Es peligroso estar por esta zona"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        
        // Trigger within a timeInterval
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //Trigger within a Location
        let centerLoc = CLLocationCoordinate2D(latitude: -34.6038148, longitude: -58.3792672)
        let region = CLCircularRegion(center: centerLoc, radius: 2000.0, identifier: UUID().uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }

}


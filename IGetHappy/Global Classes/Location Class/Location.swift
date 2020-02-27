//
//  Location.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import MapKit



class Location: NSObject, CLLocationManagerDelegate
{
    static let sharedInstance = Location()
    var locationManager: CLLocationManager!
    
    var lat:Double?
    var lng:Double?
    
    private override init()
    {
        super.init()
        // self.InitilizeGPS()
    }
    
    func InitilizeGPS()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        print(lat ?? "Blank")
        print(lng ?? "Blank")
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lat = 30.7046
        lng = 76.7179
    }
    
    func GetCurrentLocation() -> CLLocationCoordinate2D {
        var locat = CLLocationCoordinate2D()
        
        locat.latitude = lat!
        locat.longitude = lng!
        return locat
    }
    
}


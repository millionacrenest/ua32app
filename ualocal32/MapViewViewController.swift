//
//  MapViewViewController.swift
//  ualocal32
//
//  Created by Allison Mcentire on 6/14/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    let newPin = MKPointAnnotation()
    
    let locationManager =  CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // User's location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        // add gesture recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewViewController.mapLongPress(_:))) // colon needs to pass through info
        longPress.minimumPressDuration = 1.5 // in seconds
        //add gesture recognition
        mapView.addGestureRecognizer(longPress)

    
    }
    
    func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        print("A long press has been detected.")
        
        let touchedAt = recognizer.location(in: self.mapView) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
        
        let newPin = MKPointAnnotation()
        newPin.coordinate = touchedAtCoordinate
        mapView.addAnnotation(newPin)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)
        
    }

  
}

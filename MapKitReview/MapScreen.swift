//
//  ViewController.swift
//  MapKitReview
//
//  Created by MAC on 3/19/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        // I did this in storyboard by Control-Dragging the mapview onto the view controller
        // mapView.delegate = self
    }
    
    func setupLocationManager() {
        // Lets locationManager have access to the extension below
        locationManager.delegate = self
        // Sets desired accuracy (I just typed "best")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        // If there's a location for the user, center on it and zoom in to regionInMeters
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        // Checks global location services on the device
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert to allow this
        }
    }
    
    func checkLocationAuthorization() {
        // Individual app authorizations
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Do Map Stuff
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show Alert instructing how to turn on permissions
            break
        case .notDetermined:
            // Asks for permission
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show Alert letting user know they're restricted
            break
        case .authorizedAlways:
            break
        }
    }


}
        

extension MapScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Updates the mapView as the user moves locations
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // When you hit "Allow" the mapView centers on the users location
        checkLocationAuthorization()
    }
}

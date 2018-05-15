//
//  AddressSearchMapViewController.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/25/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class AddressSearchMapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var newMapView: MKMapView!
    
    var lati: CLLocationDegrees?
    var long: CLLocationDegrees?
    
    var newAddress: String?
    var newWebsite: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newMapView.delegate = self
        Activity.shared.startActivityIndicator(view: view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(newAddress!) {
            (placemarks, error) in
            guard error == nil else {
                self.alertTheUserWithAction(title: "Couldnt find your location", message: "Please try another location")
                return
            }
            let placemark = placemarks?.first
            self.lati = placemark?.location?.coordinate.latitude
            self.long = placemark?.location?.coordinate.longitude
            
            
            let latt = CLLocationDegrees(self.lati!)
            let longg = CLLocationDegrees(self.long!)
            
        
            // zooming the map to my location
            let Location = CLLocationCoordinate2D(latitude: self.lati!, longitude: self.long!);
            let region = MKCoordinateRegion(center: Location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            self.newMapView.setRegion(region, animated: true);
            
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
            annotation.title = self.newAddress
            annotation.subtitle = self.newWebsite
            self.newMapView.addAnnotation(annotation)
            Activity.shared.stopActivityIndicator()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        
        return pin
    }
    
    @IBAction func placeNewAddress(_ sender: Any) {
        
        OnTheMapFunc.shared.updateCurrentUser(latitude: self.lati as! Double, Longitude: self.long as! Double,mediaURL: newWebsite!){ (error: String?) in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    self.alertTheUser(title: "Connection Error", message: "Please check your connection")
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    private func alertTheUser(title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func alertTheUserWithAction(title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler:{(action)in
                self.dismiss(animated: true, completion: nil)
            } ))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
}

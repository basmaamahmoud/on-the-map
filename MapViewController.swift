//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/22/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var sessionId: String? = nil
    var userId: String? = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        initializeLocationManager()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
        Activity.shared.startActivityIndicator(view: view)
        StudentsParseData.Instance.getStudentsInform(){(error: String?)in
            DispatchQueue.main.sync {
                guard error == nil else{
                    // handel error
                    if error == "Connection Error"{
                        self.alertTheUser(title: "Connection Error", message: "Please check your internet connection")
                    } else if error == "Cant download Students data" {
                        self.alertTheUser(title: "Cant download Student data", message: "Problem in downloading")
                    }
                    else{
                        self.alertTheUser(title: "Can't find students information response", message: "message")
                    }
                    return
                }
                Activity.shared.stopActivityIndicator()
                self.putStudentAnnot()
            }
        }
    }
    
    func putStudentAnnot(){
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        
        for student in Storage.shared.students {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = student.fullName
            annotation.subtitle = student.mediaUrl
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
    }
    
    func initializeLocationManager() {
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.requestWhenInUseAuthorization();
        manager.startUpdatingLocation();
        
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
    
    
    //Open user's link when pin annotation is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = NSURL(string: view.annotation!.subtitle as! String){
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    
    @IBAction func logoutButtn(_ sender: Any) {
        
        OnTheMapFunc.shared.deleteSession{ (error) -> Void in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    if error == "Error loading data"{
                        self.alertTheUser(title: "Error loading data", message: "message")
                    }else{
                        self.alertTheUser(title: "Connection Error", message: "Please try again")
                    }
                    return
                }
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func refreshButtn(_ sender: Any) {
        
        Activity.shared.startActivityIndicator(view: view)
        
        StudentsParseData.Instance.getStudentsInform(){(error: String?)in
            DispatchQueue.main.sync {
                guard error == nil else{
                    // handel error
                    if error == "Connection Error"{
                        self.alertTheUser(title: "Connection Error", message: "Please check your internet connection")
                    } else if error == "Cant download Students data" {
                        self.alertTheUser(title: "Cant download Student data", message: "Problem in downloading")
                    }
                    else{
                        self.alertTheUser(title: "Can't find students information response", message: "message")
                    }
                    return
                }
                Activity.shared.stopActivityIndicator()
                self.putStudentAnnot()
            }
        }
    }
    
    @IBAction func addButtn(_ sender: Any) {
        // getting user unique key
        let checkUniqueKey = OnTheMapFunc.shared.userId
        
        // check if the user already posted a location or not
        for checkKey in Storage.shared.students{
            if checkKey.uniqueKey == checkUniqueKey{
                Storage.shared.student = checkKey
                
                alertTheUserWithAction(title: "Warning", message: "Are you sure you want to change your Location")
                
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
            
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler:{(action)in
                self.performSegue(withIdentifier: "ShowAddLocation", sender: nil)
            } ))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{(action)in
                alert.dismiss(animated: true, completion: nil)
            } ))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
}




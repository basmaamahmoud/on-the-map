//
//  UserNewLocationEditingViewController.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/23/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import UIKit



class UserNewLocationEditingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var websiteLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.delegate = self
        websiteLabel.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let moveValue: CGFloat = UIDevice.current.orientation.isLandscape ? 100.0 : 150.0
        animateViewMoving(up: true, moveValue: moveValue)
        
    }
    
    
    // this function to return back the view down according to the keyboard were dismissed
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        let moveValue: CGFloat = UIDevice.current.orientation.isLandscape ? 100.0 : 150.0
        animateViewMoving(up: true, moveValue: -moveValue)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = (self.view.frame).offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    @IBAction func findLocationButtn(_ sender: Any) {
        
        let x = "https://"
        let xArray = Array(x)
        
        if locationLabel.text == "" || websiteLabel.text == ""{
            self.alertTheUser(title: "Location and Website are required", message: "Please enter Location and Website in The Text Fields")
        }else if (websiteLabel.text?.count)! < x.count{
            
            self.alertTheUser(title: "Please enter a valid website URL", message: "message")
            
        }else{
            
            let check = Array(websiteLabel.text!)
            for C in 0...x.count-1{
                if xArray[C] != check[C] {
                    self.alertTheUser(title: "Website Field must start with https://", message: "message")
                }
            }
          
            performSegue(withIdentifier: "ShowNewAddressOnMap", sender: nil)
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewAddressOnMap" {
            if let controller = segue.destination as? AddressSearchMapViewController {
                print(locationLabel.text)
                print(websiteLabel.text)
                controller.newAddress = locationLabel.text
                controller.newWebsite = websiteLabel.text
            }
        }
    }
    
    @IBAction func cancelButtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func alertTheUser(title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


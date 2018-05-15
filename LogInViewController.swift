//
//  ViewController.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/18/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtnOutlet: UIButton!
    @IBOutlet weak var signUpButtnOutlet: UIButton!
    @IBOutlet weak var facebookButtnOutlet: UIButton!
    
    var sessionId: String? = nil
    var userId: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // get student information and store it in an array of type studentIn struct
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
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let moveValue: CGFloat = UIDevice.current.orientation.isLandscape ? 150.0 : 200.0
        animateViewMoving(up: true, moveValue: moveValue)
        
    }
    
    
    // this function to return back the view down according to the keyboard were dismissed
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        let moveValue: CGFloat = UIDevice.current.orientation.isLandscape ? 150.0 : 200.0
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
    
    
    @IBAction func loginButtn(_ sender: Any) {
        
        
        if emailTextField.text == "" || passwordTextField.text == ""{
            self.alertTheUser(title: "Email And Password are Required", message: "Please enter Email and Password in The Text Field")
        }
        else{
            OnTheMapFunc.shared.createSession(username: emailTextField.text!,password: passwordTextField.text!){ (error: String?) in
                DispatchQueue.main.async {
                    
                    guard error == nil else {
                        if error == "Username or password is incorrect"{
                            self.alertTheUser(title: "Username or password is incorrect", message: "Please try again")
                        }else if error == "Error loading data"{
                            self.alertTheUser(title: "Error loading data", message: "message")
                        }else{
                            self.alertTheUser(title: "Connection Error", message: "Please check your connection")
                        }
                        return
                    }
                    
                    self.performSegue(withIdentifier: "MapIdentifier", sender: nil)
                }
            }
        }
        
    }
    
    
    @IBAction func signUpButtn(_ sender: Any) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.shared.openURL(url as URL)
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
    
    
}

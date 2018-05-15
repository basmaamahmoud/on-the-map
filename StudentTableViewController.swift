//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Basma Ahmed Mohamed Mahmoud on 3/22/18.
//  Copyright © 2018 Basma Ahmed Mohamed Mahmoud. All rights reserved.
//

import UIKit

class StudentTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var studentTableView: UITableView!
    
    let picture = "icon_pin"
    var array = [String]()
    var arrayWebsite = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentTableView.delegate = self
        studentTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    //   number of row(images) in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Storage.shared.students.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        print(Storage.shared.students)
        for name in Storage.shared.students {
            array.append(name.fullName)
            arrayWebsite.append(name.mediaUrl)
        }
        cell.studentNameAndWebsite.text = array[indexPath.row]
        cell.studentNameAndWebsite.text = cell.studentNameAndWebsite.text! + "\n" + arrayWebsite[indexPath.row]
        cell.imagepin.image = UIImage(named: picture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = NSURL(string: arrayWebsite[indexPath.row] as! String){
            UIApplication.shared.openURL(url as URL)
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
    
    @IBAction func refreshButtn(_ sender: Any) {
        DispatchQueue.main.async {
            
            StudentsParseData.Instance.getStudentsInform(){(error: String?)in
                DispatchQueue.main.sync {
                    guard error == nil else{
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
            self.studentTableView.reloadData()
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
                self.performSegue(withIdentifier: "ShowAddLocationTable", sender: nil)
            } ))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{(action)in
                alert.dismiss(animated: true, completion: nil)
            } ))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

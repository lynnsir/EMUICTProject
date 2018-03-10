//
//  StudentSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit



class StudentSearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var track = ["Database & Intelligent Systems", "Software Engineering", "Computer Science" , "Computer Network" , "Multimedia" , "E-Business" , "Management Information System" , "Health Information Technology" ]
    let trackPicker = UIPickerView()



    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    
    
    @IBAction func SearchPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentReport") as? StudentReportViewController
            
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            vc.name = name.text!
            vc.year = year.text!
            vc.maj = major.text!
            vc.sid = studentID.text!
    
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        trackPicker.delegate = self
        trackPicker.dataSource = self
        major.inputView = trackPicker
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return track.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return track[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        major.text = track[row]
        self.view.endEditing(false)
    }
    

  

    
}

//
//  AlumniSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class AlumniSearchViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    
    var track = ["Database & Intelligent Systems", "Software Engineering", "Computer Science" , "Computer Network" , "Multimedia" , "E-Business" , "Management Information System" , "Health Information Technology" ]
    let trackPicker = UIPickerView()
    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var career: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchPressed(_ sender: Any) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlumniReport") as? AlumniReportViewController
            
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            vc.name = fullname.text!
            vc.career = career.text!
            vc.major = major.text!
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
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

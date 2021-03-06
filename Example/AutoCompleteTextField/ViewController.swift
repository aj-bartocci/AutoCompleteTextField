//
//  ViewController.swift
//  AutoCompleteTextField
//
//  Created by Neil Francis Ramirez Hipona on 03/19/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import UIKit
import AutoCompleteTextField


class ViewController: UIViewController, AutoCompleteTextFieldDataSource, AutoCompleteTextFieldDelegate {
    
    @IBOutlet weak var txtEmail: AutoCompleteTextField!
    @IBOutlet weak var txtReEmail: AutoCompleteTextField!
    @IBOutlet weak var txtPassword: AutoCompleteTextField!
    
    let domainNames = ["gmail.com",
                       "yahoo.com",
                       "hotmail.com",
                       "aol.com",
                       "comcast.net",
                       "me.com",
                       "msn.com",
                       "live.com",
                       "sbcglobal.net",
                       "ymail.com",
                       "icloud.com"]
    
    // add weighted domain names
    var weightedDomains: [WeightedDomain] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Optional setting for delegate if not setted in IB
        //        txtEmail.autoCompleteTextFieldDataSource = self
        txtEmail.autoCompleteTextFieldManualDataSource = self
        txtReEmail.autoCompleteTextFieldDataSource = self
        
        txtEmail.setDelimiter("@")
        txtReEmail.setDelimiter("@")
        
        txtEmail.autoCompleteTextFieldDelegate = self
        txtReEmail.autoCompleteTextFieldDelegate = self
        
        // Show right side complete button
        txtEmail.showAutoCompleteButtonWithImage(viewMode: .whileEditing)
        txtReEmail.showAutoCompleteButtonWithImage(viewMode: .whileEditing)
        
        // Initializing with datasource and delegate
        /*let textFieldWithDelegateAndDataSource = AutoCompleteTextField(frame: CGRect(x: 20, y: 64, width: view.frame.width - 40, height: 40), autoCompleteTextFieldDataSource: self)
         textFieldWithDelegateAndDataSource.backgroundColor = .red
         view.addSubview(textFieldWithDelegateAndDataSource)*/
        
        let g1 = WeightedDomain(text: "gmail.com", weight: 10)
        let g2 = WeightedDomain(text: "googlemail.com", weight: 5)
        let g3 = WeightedDomain(text: "google.com", weight: 4)
        let g4 = WeightedDomain(text: "georgetown.edu", weight: 1)
        weightedDomains = [g1, g2, g3, g4]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AutoCompleteTextFieldDataSource
    
    func autoCompleteTextFieldDataSource(_ autoCompleteTextField: AutoCompleteTextField) -> [String] {
        
        return AutoCompleteTextField.domainNames // domainNames
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtEmail {
            return txtReEmail.becomeFirstResponder()
        } else if textField == txtReEmail {
            return txtPassword.becomeFirstResponder()
        } else {
            return txtPassword.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, changeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        print("tf: \(textField.text!) \(string)")
        
        return true
    }
    
}

extension ViewController: AutoCompleteTextFieldManualDataSource {
    
    func autoCompleteTextField(_ autoCompleteTextField: AutoCompleteTextField, suggestionFor text: String) -> String? {
        
        let lowered = text.lowercased()
        let filtered = weightedDomains.filter { (domain) -> Bool in
            return domain.text.lowercased().contains(lowered)
            }.sorted { (d1, d2) -> Bool in
                return d1.weight > d2.weight && d1.text < d2.text
        }
        
        return filtered.first?.text
    }
}


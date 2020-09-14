//
//  EditProfileViewController.swift
//  S&BMarket
//
//  Created by Crypto on 9/1/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

    //MARK: - Vars
    let myHud = JGProgressHUD(style: .dark)
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTFOutlet: UITextField!
    @IBOutlet weak var lastNameTFOutlet: UITextField!
    
    @IBOutlet weak var addressTFOutlet: UITextField!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)

        firstNameTFOutlet.addTarget(self, action:#selector(textFieldChanged), for: UIControl.Event.editingChanged)
        lastNameTFOutlet.addTarget(self, action: #selector(textFieldChanged), for: UIControl.Event.editingChanged)
        addressTFOutlet.addTarget(self, action: #selector(textFieldChanged), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func doneButtonAction(_ sender: Any) {
        finishEditingProfile()
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldChanged () {
        
        updateDoneButtonStatus()
    }
    
    
    // MARK: - Support Functions
    
    func updateDoneButtonStatus() {
        
        if firstNameTFOutlet.text != "" && firstNameTFOutlet.text != " " && lastNameTFOutlet.text != "" && lastNameTFOutlet.text != " " && addressTFOutlet.text != "" && addressTFOutlet.text != " " {
            doneButtonOutlet.isEnabled = true
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        else {
            doneButtonOutlet.isEnabled = false
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    
    private func finishEditingProfile() {
        
        let withValues = [ConstantUserFirstName: firstNameTFOutlet.text!, ConstantUserLastName: lastNameTFOutlet.text!,ConstantUserFullName: (firstNameTFOutlet.text! + " " + lastNameTFOutlet.text!) ,ConstantFullAdress: addressTFOutlet.text!, ConstantLoggedIn: true ] as [String: Any]
        
        updateUserInfireStore(withValues: withValues) { (error) in
            
            if error == nil {
                self.myHud.textLabel.text = " Profile Updated"
                self.myHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("error is \(error!.localizedDescription)")
                self.myHud.textLabel.text = " Error while updating!"
                self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
            }
        }
    }
}

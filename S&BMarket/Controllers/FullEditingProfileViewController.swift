//
//  FullEditingProfileViewController.swift
//  S&BMarket
//
//  Created by Crypto on 9/2/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import JGProgressHUD

class FullEditingProfileViewController: UIViewController {
      // MARK: - Outlets
    @IBOutlet weak var userFirstNameTFOutlet: UITextField!
    
    @IBOutlet weak var userLastNameTFOutlet: UITextField!
    
    @IBOutlet weak var userAddressTFOutlet: UITextField!
    
    
    
    
    // MARK: - Vars
    
    let myHud = JGProgressHUD(style: .dark)
    
   // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfoToUI()
//        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backtoView))]
//        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
         self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - IBActions
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if checkTextFieldHasText() {

            let withValues = [ConstantUserFirstName: userFirstNameTFOutlet.text!, ConstantUserLastName: userLastNameTFOutlet.text!,ConstantUserFullName: (userFirstNameTFOutlet.text! + " " + userLastNameTFOutlet.text!) ,ConstantFullAdress: userAddressTFOutlet.text!]

                  updateUserInfireStore(withValues: withValues) { (error) in

                      if error == nil {
                          self.myHud.textLabel.text = " Profile Updated"
                          self.myHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                          self.myHud.show(in: self.view)
                          self.myHud.dismiss(afterDelay: 2.5)
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
        else {
            myHud.textLabel.text = "All Fields are required!!"
            myHud.indicatorView = JGProgressHUDErrorIndicatorView()
            myHud.show(in: self.view)
            myHud.dismiss(afterDelay: 3)
        }
        dismissKeyboard()
    }
    
    @IBAction func logOutButtonAction(_ sender: Any) {
        UserLogout()
    }
    
    @objc func backtoView() {
//           self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)

       }
    
     // MARK: - Support Functions
    
    func dismissKeyboard () {
        self.view.endEditing(false)
    }
    
    func checkTextFieldHasText () -> Bool {
        return (userFirstNameTFOutlet.text != "" && userFirstNameTFOutlet.text != " " && userLastNameTFOutlet.text != "" && userLastNameTFOutlet.text != " " && userAddressTFOutlet.text != "" && userAddressTFOutlet.text != " ")
    }
    
     //MARK: - Update UI Info
    
    func loadUserInfoToUI () {
        if User.returnCurrentUser() != nil {
            let currentUser = User.returnCurrentUser()
            userFirstNameTFOutlet.text = currentUser!.firstName
            userLastNameTFOutlet.text = currentUser!.lastName
            userAddressTFOutlet.text = currentUser!.fullAdress
        }
    }
    
    // MARK: log out
    
    private func UserLogout() {
        User.userLogOut { (error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print ("error is \(error!.localizedDescription)")
            }
        }
    }
}

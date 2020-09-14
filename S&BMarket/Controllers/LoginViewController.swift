//
//  LoginViewController.swift
//  S&BMarket
//
//  Created by Crypto on 8/27/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView


class LoginViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    
    //MARK: - Vars
    
    let myHud = JGProgressHUD.init(style: .dark)
    var myActivity: NVActivityIndicatorView?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFieldOutlet.addTarget(self, action:#selector(textFieldChanged), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        myActivity = NVActivityIndicatorView(frame: CGRect(x:  self.view.frame.width / 2 - 30, y: self.view.frame.width / 2 - 30, width: 60.0, height: 60.0), type: .ballRotateChase, color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), padding: nil)
        resendEmailButtonOutlet.isHidden = true

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - IBActions
    
    @objc func textFieldChanged () {
        
        updateResendMailButtonStatus()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        dismissView()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        useLoginWith()
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        if emptyTextFieldsCheck() {
            userRegisterWith()
        }
            
        else {
            
            if (emailTextFieldOutlet.text != "" && emailTextFieldOutlet.text != " " ) == false {
                myHud.textLabel.text = "All fields are required "
                myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                myHud.show(in: self.view)
                myHud.dismiss(afterDelay: 2.5)
            }
            
            if (passwordTextFieldOutlet.text != "" && passwordTextFieldOutlet.text != " " && passwordTextFieldOutlet.text!.count < 8) == false {
                myHud.textLabel.text = "Password must be more than 8 letters"
                myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                myHud.show(in: self.view)
                myHud.dismiss(afterDelay: 2.5)
                
            }
            
            
        }
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        if emailTextFieldOutlet.text != "" && emailTextFieldOutlet.text != " " {
            resetUserPassword()
        }
            else {
                self.myHud.textLabel.text = "Please insert an email!"
                self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
            }
        }
    
    @IBAction func resendEmailButtonAction(_ sender: Any) {
        if emailTextFieldOutlet.text != "" && emailTextFieldOutlet.text != " " {
            resendEmailButtonOutlet.isHidden = false
        User.resendEmailVerification(email: emailTextFieldOutlet.text!) { (error) in
            print("Error resending the mail \(error?.localizedDescription ?? " ")")
            
            }
        }
        else {
            self.myHud.textLabel.text = "Please insert an email!"
                           self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                           self.myHud.show(in: self.view)
                           self.myHud.dismiss(afterDelay: 2.5)
        }
    }
    
    
    
    
    //MARK: - Register User
    
    func userRegisterWith() {
        
        showActivityIndicator()
        User.UserRegistrWith(email: emailTextFieldOutlet.text!,Password: passwordTextFieldOutlet.text!) { (error) in
            if error == nil {
                self.myHud.textLabel.text = "Verification Mail sent"
                self.myHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
            }
            else {
                self.myHud.textLabel.text = error!.localizedDescription
                self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
            }
            
            self.hideActivityIndicator()
            
        }
        
    }
    
    // MARK: - User Login
    func useLoginWith() {
        
        showActivityIndicator()
        User.UserLoginWith(email: emailTextFieldOutlet.text!, Password: passwordTextFieldOutlet.text!) { (error, isEmailVerified) in
            
            if error == nil {
                
                if isEmailVerified {
                    self.dismissView()
                }
                else {
                    
                    self.myHud.textLabel.text = "Please Verify your email"
                    self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.myHud.show(in: self.view)
                    self.myHud.dismiss(afterDelay: 2.5)
                    self.resendEmailButtonOutlet.isHidden = false
                }
            }
            else {
                self.myHud.textLabel.text = error!.localizedDescription
                self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
            }
            self.hideActivityIndicator()
        }
    }
    
    // MARK: - Support Functions
    
    func updateResendMailButtonStatus() {
           
        if (emailTextFieldOutlet.text != "" && emailTextFieldOutlet.text != " " && emailTextFieldOutlet.text!.count > 8 ) == false{
               resendEmailButtonOutlet.isEnabled = true
               resendEmailButtonOutlet.isHidden = true
           }
           else {
               resendEmailButtonOutlet.isEnabled = false
               resendEmailButtonOutlet.isHidden = false
           }
       }
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func emptyTextFieldsCheck () -> Bool {
        
        return(emailTextFieldOutlet.text != "" && emailTextFieldOutlet.text != " " && passwordTextFieldOutlet.text != "" && passwordTextFieldOutlet.text != " ")
        
    }
    
    private func resetUserPassword() {
        User.resetPassword(email: emailTextFieldOutlet.text!) { (error) in
            if error == nil {
                self.myHud.textLabel.text = "Reset password email sent successfully"
                self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 3)
            }
            else {
                self.myHud.textLabel.text = error!.localizedDescription
                self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
            }
        }
    }
    
    func showActivityIndicator () {
        if myActivity != nil {
            self.view!.addSubview(self.myActivity!)
            myActivity!.startAnimating()
        }
    }
    
    func hideActivityIndicator (){
        if myActivity != nil {
            myActivity!.removeFromSuperview()
            myActivity!.stopAnimating()
        }
    }
}

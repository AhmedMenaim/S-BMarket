//
//  ProfileTableViewController.swift
//  S&BMarket
//
//  Created by Crypto on 9/1/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var finishRegisterationButtonOutlet: UIButton!
    
    @IBOutlet weak var purshaceHistoryButtonOutlet: UIButton!
    
    
    // MARK: - Vars
    
     var editBarButtonItem: UIBarButtonItem!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLoginStatus()
        checkUserStillLoginStatus()

    }
    
    // MARK: - Bar Button Func
    
    @objc func rightBarButtonItemPressed () {
        if editBarButtonItem.title == "Login" {
            showLoginView ()
        }
        else {
            goToEditView()
            
        }
    }
    
    @IBAction func finishRegisterationAction(_ sender: Any) {
        if finishRegisterationButtonOutlet.titleLabel!.text == "Finish Registeration" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EditProfileViewController")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    func showLoginView () {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
        self.present(loginView, animated: true, completion: nil)
    }
    
    func goToEditView () {
        performSegue(withIdentifier: "finishEditingProfileSegue", sender: self)
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        return UITableViewCell()
//    }
    

    // MARK: - Navigation

//    func navigateToView() {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FullEditingProfileViewController")
//        navigationController?.pushViewController(vc, animated: true)
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
   

    // MARK: - Support Functions
    func checkUserStillLoginStatus() {
        if User.returnCurrentUser() != nil {
            if User.returnCurrentUser()!.LoggedIn {
                finishRegisterationButtonOutlet.setTitle("Account is Active", for: .normal)
                finishRegisterationButtonOutlet.isEnabled = false
                purshaceHistoryButtonOutlet.isEnabled = true
                purshaceHistoryButtonOutlet.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                
            }
            else {
                 finishRegisterationButtonOutlet.setTitle("Finish Registeration", for: .normal)
                finishRegisterationButtonOutlet.isEnabled = true
                finishRegisterationButtonOutlet.tintColor = .red
                purshaceHistoryButtonOutlet.isEnabled = false
                purshaceHistoryButtonOutlet.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)


            }
        }
        else {
            finishRegisterationButtonOutlet.setTitle("Logged Out", for: .normal)
            finishRegisterationButtonOutlet.isEnabled = false
            finishRegisterationButtonOutlet.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            purshaceHistoryButtonOutlet.isEnabled = false
            purshaceHistoryButtonOutlet.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    func checkLoginStatus() {
        if User.returnCurrentUser() == nil {
            createRightBarButton(title: "Login", color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
        }
        else {
            createRightBarButton(title: "Edit", color: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1))

        }
    }
    func createRightBarButton (title: String, color: UIColor) {
        editBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        editBarButtonItem.tintColor = color
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    
}

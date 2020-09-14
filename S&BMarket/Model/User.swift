//
//  User.swift
//  S&BMarket
//
//  Created by Crypto on 8/31/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    
    let generalID: String
    let userEmail: String
    let firstName: String
    let lastName: String
    let fullName: String
    let purchasedItemsIDs: [String]
    
    let fullAdress: String?
    let LoggedIn: Bool
    
    //MARK: - Initializers
    
    init(_generalID: String, _userEmail: String, _firstName: String, _lastName: String, _fullName: String ) {
        
        generalID = _generalID
        userEmail = _userEmail
        firstName = _firstName
        lastName = _lastName
        fullName = _fullName + " " + _lastName
        fullAdress = ""
        purchasedItemsIDs = []
        LoggedIn = false
    }
    
    init(myDictionary: NSDictionary) {
        
        generalID = myDictionary ["ItemID"] as! String
        if let email = myDictionary[ConstantUserEmail] {
            userEmail = email as! String
        }
        else {
            userEmail = ""
        }
        
        if let fName = myDictionary[ConstantUserFirstName]{
            firstName = fName as! String
        }
        else {
            firstName = ""
        }
        
        if let LName = myDictionary[ConstantUserLastName] {
            lastName = LName as! String
        }
        else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let _fullAdress = myDictionary[ConstantFullAdress] {
            fullAdress = _fullAdress as? String
        }
        else {
            fullAdress = ""
        }
        
        if let _loggedIn = myDictionary[ConstantLoggedIn] {
            LoggedIn = _loggedIn as! Bool
        }
        else {
            LoggedIn = false
        }
        
        if let _purchasedItemsIDs = myDictionary[ConstantPurshacedItemsIDs] {
            purchasedItemsIDs = _purchasedItemsIDs as! [String]
        }
        else {
            purchasedItemsIDs = []
        }
        
    }
    
    // MARK: - Return Current User
    
    class func returnCurrentUserID () -> String{
        return Auth.auth().currentUser!.uid
    }
    
    class func returnCurrentUser () -> User?{
        if Auth.auth().currentUser != nil {
            if let myDictionary = UserDefaults.standard.object(forKey: ConstantCurrentUser){
                return User.init(myDictionary: myDictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    // MARK: - Login
    class func UserLoginWith(email: String, Password: String, completion: @escaping(_ error:Error?, _ isEmailVerified: Bool) -> Void)  {
        
        Auth.auth().signIn(withEmail: email, password: Password) { (authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    saveUserToFireStore(userID: (authDataResult?.user.uid)!, userEmail: email)
                    completion(error, true)
                }
                else {
                    completion(error, false)
                }
            }
            else {
                completion(error, false)
            }
        }
    }
    
    // MARK: - Register
    
    class func UserRegistrWith(email: String, Password: String, completion: @escaping(_ error:Error?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: Password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                authDataResult?.user.sendEmailVerification(completion: { (error) in
                    print("Error is \( String(describing: error?.localizedDescription))") // Test
                })
            }
            
        }
    }
    
    
    
    // MARK: - Resend Mails Methods
    class func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            print("error is \(error?.localizedDescription ?? " ")")
            completion(error)
            
        }
    }
    
    class func resendEmailVerification (email: String, completion: @escaping(_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print("error is \(error?.localizedDescription ?? " ")")
                completion(error)
            })
        })
    }
    
    
    // MARK: - Logout
    
    class func userLogOut (completion: @escaping(_ error: Error?) -> Void) {
        
        do {
            
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: ConstantCurrentUser)
            UserDefaults.standard.synchronize()
            completion(nil)
            
        }
        catch let error as NSError {
            completion(error)
        }
    }
}


// MARK: - Save user to FB

func saveUserToFireBase(myUser: User){
    FirebaseReference(collectionReference: .User).document(myUser.generalID).setData(userDictionaryFrom(myUser: myUser) as! [String : Any]) { (error) in
        
        if error != nil {
            print("Error is " + error!.localizedDescription)
        }
        
    }
    
}

// MARK: - Save user Locally

func saveUserLOcally(userDictionary: NSDictionary)  {
    
    UserDefaults.standard.set(userDictionary, forKey: ConstantCurrentUser)
    UserDefaults.standard.synchronize()
}

// MARK: - Save user to firebase

func saveUserToFireStore (userID: String, userEmail: String){
    FirebaseReference(collectionReference: .User).document(userID).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else {return}
        
        if snapshot.exists {
            saveUserLOcally(userDictionary: snapshot.data()! as NSDictionary)
        }
        else {
            let myUser = User(_generalID: userID, _userEmail: userEmail, _firstName: "", _lastName: "", _fullName: "")
            saveUserLOcally(userDictionary: userDictionaryFrom(myUser: myUser))
            saveUserToFireBase(myUser: myUser)
            
        }
    }
}

// MARK: - Update User in firestore
func updateUserInfireStore (withValues: [String: Any], completion: @escaping(_ error: Error?) -> Void) {
    
    if let myDictionary = UserDefaults.standard.object(forKey: ConstantCurrentUser) {
        let userObject = (myDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        FirebaseReference(collectionReference: .User).document(User.returnCurrentUserID()).updateData(withValues) { (error) in
            
            completion(error)
            if error == nil {
                saveUserLOcally(userDictionary: userObject)
            }
        }
    }
    
}


//MARK: - Support Functions

func userDictionaryFrom(myUser: User) -> NSDictionary {
    return NSDictionary(objects: [myUser.generalID, myUser.userEmail, myUser.firstName, myUser.lastName, myUser.fullName, myUser.fullAdress ?? "", myUser.LoggedIn, myUser.purchasedItemsIDs], forKeys: [ConstantItemID as NSCopying, ConstantUserEmail as NSCopying, ConstantUserFirstName as NSCopying, ConstantUserLastName as NSCopying, ConstantUserFullName as NSCopying, ConstantFullAdress as NSCopying, ConstantLoggedIn as NSCopying, ConstantPurshacedItemsIDs as NSCopying])
}


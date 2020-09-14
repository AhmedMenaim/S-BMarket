//
//  CardInfoViewController.swift
//  S&BMarket
//
//  Created by Crypto on 9/10/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import Stripe

protocol CardInfoViewControllerDelegate {
    
    func doneButtonPressed (_ token: STPToken )
    
    func cancelButtonPressed ()
    
}



class CardInfoViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    let paymentCardTextField = STPPaymentCardTextField()
    
    var delegate: CardInfoViewControllerDelegate?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)

        
        paymentCardTextField.delegate = self
        // Modifying card textfield
        
        view.addSubview(paymentCardTextField)
        paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .top, relatedBy: .equal, toItem: doneButtonOutlet, attribute: .bottom, multiplier: 1, constant: 30))
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))

        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20))
        
    }
    
    // MARK: - Actions

    @IBAction func cancelButtonAction(_ sender: Any) {
        delegate?.cancelButtonPressed()
        dismissView()
    }
    

    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        processCard()
    }
    
    
    
    // MARK: - Support funcs
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func processCard () {
        
        let cardParams = STPCardParams()
        cardParams.number = paymentCardTextField.cardNumber
        cardParams.expMonth = paymentCardTextField.expirationMonth
        cardParams.expYear = paymentCardTextField.expirationYear
        cardParams.cvc = paymentCardTextField.cvc
//        cardParams.addressZip = paymentCardTextField.
         
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            
            if error == nil {
                print("Finally we have a token which is \(token!)")
                self.delegate?.doneButtonPressed(token!)
                
                self.dismissView()
            }
            else {
                print("error processing card token \(error!.localizedDescription)")
            }
        }
    }
}

// MARK: - Payment extension

extension CardInfoViewController: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        doneButtonOutlet.isEnabled = textField.isValid
        if doneButtonOutlet.isEnabled == true {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        else {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)

        }
    }
}

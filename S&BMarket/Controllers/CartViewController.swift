//
//  CartViewController.swift
//  S&BMarket
//
//  Created by Crypto on 8/26/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import JGProgressHUD
import Stripe

class CartViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cartItemsTableViewOutlet: UITableView!
    @IBOutlet weak var numberOfItemsOutlet: UILabel!
    @IBOutlet weak var footerViewOutlet: UIView!
    @IBOutlet weak var totalPriceLblOutlet: UILabel!
    @IBOutlet weak var checkOutBtnOutlet: UIButton!
    
    // MARK: - Vars
    var myCart: Cart?
    var allItems: [Item] = []
    var cartPurchasedItemsIDs: [String] = []
    let myHud = JGProgressHUD(style: .dark)
    var totalPrice = 0.0
    
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cartItemsTableViewOutlet.tableFooterView = footerViewOutlet
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
        //        setUpPayPal()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if User.returnCurrentUser() != nil {
            
            loadCartItemsFromFireStore()
            
            
        }
        else {
            //            numberOfItemsOutlet.text = "0"
            //            self.allItems = []
            print("My all items count is \(allItems.count)")
            self.cartItemsTableViewOutlet.reloadData()
            self.updateNumberofItemsLabel(true)
            
        }
        
    }
    
    
    
    
    
    @IBAction func checkOutBtnAction(_ sender: Any) {
        if User.returnCurrentUser()!.LoggedIn {
            
            showPaymentOptions()
//            finishPayment()
            
        }
        else {
            self.showNotification(notificationText: "Please complete your profile!!", isError: true, color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
        }
    }
    
    
    
    
    // MARK: - Download Cart Items
    
    func loadCartItemsFromFireStore () {
        downloadCartItemsFromFireStore(ownerID: User.returnCurrentUserID()) { (myCart) in
            self.myCart = myCart
            self.getAllCartItems()
        }
    }
    
    func getAllCartItems(){
        
        if myCart != nil {
            
            downloadSpecificItems(myCart!.itemsIDs) { (allItems) in
                self.allItems = allItems
                self.updateNumberofItemsLabel(false)
                self.cartItemsTableViewOutlet.reloadData()
            }
            
        }
    }
    
    // MARK: - Labels Update Function
    
    func updateNumberofItemsLabel (_ isEmpty: Bool) {
        
        if isEmpty {
            numberOfItemsOutlet.text = "0"
            totalPriceLblOutlet.text = returnTotalPrice()
        }
        else {
            numberOfItemsOutlet.text = "\(allItems.count)"
            totalPriceLblOutlet.text = returnTotalPrice()
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab
                let tabItem = tabItems[2]
                tabItem.badgeValue = "\(allItems.count)"
                tabItem.badgeColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
                
            }
            //            self.tabBarController?.tabBarItem.badgeValue =
            
        }
        checkOutButtonUpdate()
    }
    
    func returnTotalPrice () -> String{
        var totalPrice = 0.0
        for item in allItems {
            totalPrice += item.itemPrice
            totalPrice += (item.itemPrice * 14) / 100
        }

        if totalPrice == 0 {
        return "Total Price: " + currencyConverter(totalPrice)
        }
        else {
            return "Total Price: " + currencyConverter(totalPrice + 30)
        }
    }
    
  
    
    
    
    // MARK: - Support Func
    
    func tempUpdatePurchasedItems () {
        
        for myItem in allItems {
            cartPurchasedItemsIDs.append(myItem.itemID)
        }
    }
    private func emptyTheCart () {
        
        cartPurchasedItemsIDs.removeAll()
        allItems.removeAll()
        cartItemsTableViewOutlet.reloadData()
        myCart!.itemsIDs = []
        updateCartDataInFireStore(myCart: myCart!, withValues: [ConstantArrayOfItemsIDS : myCart!.itemsIDs!]) { (error) in
            
            if error != nil {
                
                print("Error updating the cart \(error!.localizedDescription)")
                
            }
            self.getAllCartItems()
        }
        
    }
    
    private func adddItemsToPurchasedList (itemsIDs: [String]) {
        
        if User.returnCurrentUser() != nil {
            let newPurshacedItems = User.returnCurrentUser()!.purchasedItemsIDs + itemsIDs
            
            updateUserInfireStore(withValues: [ConstantPurshacedItemsIDs: newPurshacedItems]) { (error) in
                
                if error != nil {
                    print("Error located is \(error!.localizedDescription)")
                }
            }
        }
    }
    
    func checkOutButtonUpdate () {
        
        checkOutBtnOutlet.isEnabled = allItems.count > 0
        if checkOutBtnOutlet.isEnabled {
            checkOutBtnOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        else {
            disableCheckOutButton()
        }
    }
    
    func disableCheckOutButton(){
        checkOutBtnOutlet.isEnabled = false
        checkOutBtnOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    func removeItemfromCart (itemID: String){
        for i in 0 ..< myCart!.itemsIDs.count {
            if itemID == myCart!.itemsIDs[i] {
                
                myCart!.itemsIDs.remove(at: i)
                return
            }
        }
    }
    
    func showItemDetails (myItem: Item){
        let itemDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemDetailsViewController") as ItemDetailsViewController
        itemDetailsVC.myItem = myItem
        self.navigationController?.pushViewController(itemDetailsVC, animated: true)
    }
    
    
    // MARK: - Paying
    
    private func finishPayment(token: STPToken) {
        self.totalPrice = 0.0
        for myItem in allItems {
            cartPurchasedItemsIDs.append(myItem.itemID)
            self.totalPrice += myItem.itemPrice
            self.totalPrice += (myItem.itemPrice * 14) / 100
        }
        
        self.totalPrice = self.totalPrice + 30 // Taxes & delivery fies
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: Int(totalPrice + 1)) { (error) in
            
            if error == nil {
                self.adddItemsToPurchasedList(itemsIDs: self.cartPurchasedItemsIDs)
                self.showNotification(notificationText: "Order placed Successfully", isError: false, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                
            }
            else {
                self.showNotification(notificationText: error!.localizedDescription, isError: true, color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
//                print("Error existed \()") // test
            }
        }
    }
    
    
    private func showNotification(notificationText: String, isError: Bool,color: UIColor) {
        if isError {
            self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.myHud.indicatorView?.tintColor = color
            self.myHud.textLabel.textColor = color

        }
        else {
            self.myHud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.myHud.indicatorView?.tintColor = color
            self.myHud.textLabel.textColor = color

        }
        self.myHud.textLabel.text = notificationText
        self.myHud.show(in: self.view)
        self.myHud.dismiss(afterDelay: 3)
        
    }
    
    private func showPaymentOptions() {
        
        let alertController = UIAlertController(title: "Payment Methods", message: "Choose a prefered payment method", preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Pay with Card", style: .default) { (action) in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CardInfoViewController") as CardInfoViewController
            vc.delegate = self
            self.present(vc, animated: true)
            
        }
        let cashAction = UIAlertAction(title: "Cash on delivery", style: .default) { (action) in
            
            self.tempUpdatePurchasedItems()
            self.adddItemsToPurchasedList(itemsIDs: self.cartPurchasedItemsIDs)
            self.showNotification(notificationText: "Order placed Successfully", isError: false, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            self.emptyTheCart()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cardAction)
        alertController.addAction(cashAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true, completion: nil)

    }

    
}

// MARK: - TableView Delegate

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cartItemsTableViewOutlet.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! ItemsCell
        cell.generateItemCell(myItem: allItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cartItemsTableViewOutlet.deselectRow(at: indexPath, animated: true)
        showItemDetails(myItem: allItems[indexPath.row])
        
    }
    
    // Editing and Deleting
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemDeleted = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            cartItemsTableViewOutlet.reloadData()
            removeItemfromCart(itemID: itemDeleted.itemID)
            updateCartDataInFireStore(myCart: myCart!, withValues: [ConstantArrayOfItemsIDS : myCart!.itemsIDs!]) { (error) in
                
                if error == nil {
                    self.getAllCartItems()
                }
                else {
                    print("Uploading error is \(error!.localizedDescription)")
                }
            }
            
        }
    }
    
}


extension CartViewController: CardInfoViewControllerDelegate {
    func doneButtonPressed(_ token: STPToken) {
        finishPayment(token: token)
        print("We have token insallah \(token)")
    }
    
    func cancelButtonPressed() {
        showNotification(notificationText: "Payment Cancelled", isError: true, color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
    }
    
    

}
// MARK: - PayPal




//    var myEnvironment: String = PayPalEnvironmentNoNetwork {
//        willSet(newEnvironemt) {
//            if (newEnvironemt != myEnvironment) {
//                PayPalMobile.preconnect(withEnvironment: newEnvironemt)
//            }
//        }
//    }

//    var payPalConfig = PayPalConfiguration()




//
//    func  setUpPayPal() {
//
//        payPalConfig.acceptCreditCards = true
//        payPalConfig.merchantName = "S&B Market"
//        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//
//
//        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//        payPalConfig.payPalShippingAddressOption = .both
//
//    }

//    private func payButtonPressed() {
//
//        var itemsToBuy : [PayPalItem] = []
//
//        for item in allItems {
//            let tempItem = PayPalItem(name: item.itemName, withQuantity: 1, withPrice: NSDecimalNumber(value: item.itemPrice), withCurrency: "USD", withSku: nil)
//
//            cartPurchasedItemsIDs.append(item.itemID)
//            itemsToBuy.append(tempItem)
//        }
//
//        let subTotal = PayPalItem.totalPrice(forItems: itemsToBuy)
//
//        //optional
//        let shippingCost = NSDecimalNumber(string: "2.0")
//        let tax = NSDecimalNumber(string: "\(returnTotalTaxes())")
//
//        let paymentDetails = PayPalPaymentDetails(subtotal: subTotal, withShipping: shippingCost, withTax: tax)
//
//        let total = subTotal.adding(shippingCost).adding(tax)
//
//        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Payment to S&B Market", intent: .sale)
//
//        payment.items = itemsToBuy
//        payment.paymentDetails = paymentDetails
//
//        if payment.processable {
//
//            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
//
//            present(paymentViewController!, animated: true, completion: nil)
//
//        } else {
//            print("Payment not processable")
//        }
//    }

//extension CartViewController: PayPalPaymentDelegate {
//    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
//
//        paymentViewController.dismiss(animated: true) {
//
//            self.adddItemsToPurchasedList(itemsIDs: self.cartPurchasedItemsIDs)
//            self.emptyTheCart()
//        }
//    }
//
//
//
//}


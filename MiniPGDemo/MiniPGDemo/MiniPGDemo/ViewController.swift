//
//  ViewController.swift
//  MiniPGDemo
//
//  Created by Gogoi on 23/07/2018.
//  Copyright © 2018 Jayanta Gogoi. All rights reserved.
//

import UIKit
import MiniPG

class ViewController: UIViewController, PaymentHandshakDelegate {

    var miniPGPayment : MiniPGPayment?
    var currentSignature: String?
    
    @IBOutlet weak var lblOrderDetails: UILabel!
    @IBOutlet weak var lblOrderAmount: UILabel!
    
    
    @IBOutlet weak var btnMakePayment: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    var amount = 565.00
    var orderDetails = "Very Good Quality Example of SDK building in Swift & Backend API"
    var orderID = "DEMO67627"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentSignature = "Pre-Auth::7763::7763"
        self.miniPGPayment = MiniPGPayment()
        self.miniPGPayment?.delegate = self
        self.btnMakePayment.addTarget(self, action: #selector(onTapMakePayment(_:)), for: .touchUpInside)
        self.btnMenu.addTarget(self, action: #selector(onTapMenu(_:)), for: .touchUpInside)
        self.btnAddToCart.addTarget(self, action: #selector(onTapAddToCart(_:)), for: .touchUpInside)
        self.btnMakePayment.layer.cornerRadius = 26
        
        self.generateSignature()
        
        self.lblOrderAmount.text = "₹\(amount)"
        
        let attrString = NSMutableAttributedString()
        attrString.append(NSAttributedString(string: "Order Details: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19), NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
        
        attrString.append(NSAttributedString(string: "\(orderDetails)\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
        
        attrString.append(NSAttributedString(string: "\nOrder ID: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19), NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
        
        attrString.append(NSAttributedString(string: "\(orderID)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
        
        self.lblOrderDetails.attributedText = attrString
        self.lblOrderDetails.numberOfLines = 0
        self.lblOrderDetails.lineBreakMode = .byWordWrapping
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Call MiniPG Events
    func generateSignature(){
        
        let fields: [String: Any] = ["mid": "AXC6767", "AppID": "AKJ7863","amount": self.amount]
        self.miniPGPayment?.generatePaymentSignature(fields: fields)
     }
    
    
    @objc func onTapMakePayment(_ sender: UIButton) {
        
        sender.onTapAnimation()
        
        guard let signature = self.currentSignature else { return }
        
        let fields: [String: Any] = ["orderId": "\(self.orderID)", "amount": self.amount,"currency": "INR", "appId": "AKBARTRAVELS-SANDBOX-2763", "signature": "\(signature)","orderDesc": "\(self.orderDetails)"]
            self.miniPGPayment?.pay(fields: fields, viewController: self)
            
        
        
    }

    
    @objc func onTapMenu(_ sender: UIButton) {
        
        sender.onTapAnimation()
    }
    
    @objc func onTapAddToCart(_ sender: UIButton) {
        
        sender.onTapAnimation()
    }
    
    //MARK: - MiniPG delegate
    func didReceivedPaymentSignature(signature: String) {
        
        self.currentSignature = signature
        print("Signature received \(signature)")
    }

    func didFailedPaymentSignature(error: String) {
        
        print("Signature Error description \(error)")
    }
    
    func didReceivedPayment(paymentInfo: [String: Any]?){
        
        print("received Payment....\(paymentInfo!)")
        
    }
    
    func didReceivedFailedPayment(erro: Error?){
        
        print("Failed to received payment")
    }

}


extension UIView{
    
    func onTapAnimation(){
        
        DispatchQueue.main.async {
            let anim = CAKeyframeAnimation(keyPath: "transform.scale")
            anim.values = [0.9,0.8,1.1,1.0]
            anim.keyTimes = [0.1,0.3,0.6,0.9,1.2]
            anim.duration = 0.3
            self.layer.add(anim, forKey:"scale")
            
        }
    }
    
}


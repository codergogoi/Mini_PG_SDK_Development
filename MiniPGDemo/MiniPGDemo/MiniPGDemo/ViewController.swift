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
    
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var textLogs: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentSignature = "Pre-Auth::7763::7763"
        self.miniPGPayment = MiniPGPayment()
        self.miniPGPayment?.delegate = self
        
        self.generateSignature()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Call MiniPG Events
    func generateSignature(){
        
        let fields: [String: Any] = ["mid": "AXC6767", "AppID": "AKJ7863","amount": 1.0]
        self.miniPGPayment?.generatePaymentSignature(fields: fields)
     }
    
    
    @IBAction func onTapMakePayment(_ sender: Any) {
        
        guard let signature = self.currentSignature else { return }
        
        if let amount = self.textAmount.text{
            let fields: [String: Any] = ["orderId": "XC386871", "amount": 100.00,"currency": "INR", "appId": "SENDBOX-07", "signature": "\(signature)","orderDesc": "Test Product : PID100"]
            self.miniPGPayment?.pay(fields: fields, viewController: self)
            
        }else{
            
            let alertCont = UIAlertController(title: "Amount is Empty", message: "Please enter a valid amount", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertCont.addAction(action)
            self.present(alertCont, animated: true, completion: nil)
        }
        
        
        
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


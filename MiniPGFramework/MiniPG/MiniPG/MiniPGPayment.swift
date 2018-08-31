//
//  MiniPGPayment.swift
//  MiniPG
//
//  Created by Gogoi on 23/07/2018.
//  Copyright © 2018 Jayanta Gogoi. All rights reserved.
//

import Foundation

public protocol PaymentHandshakDelegate {

    func didReceivedPaymentSignature(signature: String)
    func didFailedPaymentSignature(error: String)
    func didReceivedPayment(paymentInfo: [String: Any]?)
    func didReceivedFailedPayment(erro: Error?)
}

protocol PaymentConfirmationDelegate {
    
    func didSuccessPayment(paymentInfo: [String: Any]?)
    func didFailedPayment(erro: Error?)
    
}

struct MiniFields{
    var orderID: String?
    var amount: Double?
    var currency: String?
    var appID: String?
    var signature: String?
    var orderDesc: String?
}

public final class MiniPGPayment: NSObject, PaymentConfirmationDelegate{
    
    private var baseURL: String = "http://jayantagogoi.com/api/payment/" //
    
    private var hashManager: HashManager?
    
    public var delegate: PaymentHandshakDelegate?
    
    
    public override init() {
        self.hashManager = HashManager()
        self.hashManager?.initWithURL(url: baseURL)
    }
    
    public func generatePaymentSignature(fields:[String: Any]){
        //perform API
        
        self.hashManager?.generateHash(fields, handler: { (responseDictionary, err) in
            
            if err == nil{
                 //fire delegate notification as per success
                self.delegate?.didReceivedPaymentSignature(signature: "some Signature.....")
            }else{
                //fire delegate notification as per success
                self.delegate?.didFailedPaymentSignature(error: "Some error Occured!")
            }
            
        })
       
    }
    
    public func pay(fields: [String: Any], viewController: UIViewController){
        
        let bundle = Bundle(for: PaymentProcessController.self)
        
        guard let orderId = fields["orderId"] as? String, let amount = fields["amount"] as? Double, let currency = fields["currency"] as? String, let appID = fields["appId"] as? String, let signature = fields["signature"] as? String, let orderDesc = fields["orderDesc"] as? String else {
            
            let paymentProcessController = UIStoryboard.init(name: "MiniPGInterface", bundle: bundle).instantiateViewController(withIdentifier: "makePayment") as! PaymentProcessController
            paymentProcessController.delegate = self
            paymentProcessController.requestFields = nil
            viewController.present(paymentProcessController, animated: true, completion: nil)
            
            return
        }
        
        let miniFields = MiniFields(orderID: orderId, amount: amount, currency: currency, appID: appID, signature: signature, orderDesc: orderDesc)
        
        let paymentProcessController = UIStoryboard.init(name: "MiniPGInterface", bundle: bundle).instantiateViewController(withIdentifier: "makePayment") as! PaymentProcessController
        paymentProcessController.delegate = self
        paymentProcessController.requestFields = miniFields
        viewController.present(paymentProcessController, animated: true, completion: nil)
    }
    
    public func pay(fields: [String: Any], NavigationController: UINavigationController){
 
    }
    
    //MARK: - payment Confirmation Delegate
    func didSuccessPayment(paymentInfo: [String : Any]?) {
         print("Payment Success")
    }
    
    func didFailedPayment(erro: Error?) {
        
        print("Payment failed!")
    }
    
    
}



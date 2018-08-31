//
//  PaymentProcessController.swift
//  MiniPG
//
//  Created by Gogoi on 23/07/2018.
//  Copyright © 2018 Jayanta Gogoi. All rights reserved.
//

import UIKit




public class PaymentProcessController: UIViewController {
 
    var delegate: PaymentConfirmationDelegate?

    var requestFields: MiniFields?
    
    @IBOutlet weak var btnMakePayment: UIButton!
    @IBOutlet weak var btnCancelPayment: UIButton!
    
    @IBOutlet weak var btnCreditCard: UIButton!
    @IBOutlet weak var btnDebitCard: UIButton!

    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var merchantView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCardExpDate: UITextField!
    @IBOutlet weak var txtCardCVV: UITextField!
    
    @IBOutlet weak var lblOrderInfo: UILabel!
    @IBOutlet weak var lblMerchantInfo: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        btnMakePayment.addTarget(self, action: #selector(onTapMakePayment(_:)), for: .touchUpInside)
        btnCancelPayment.addTarget(self, action: #selector(onTapCancelPayment(_:)), for: .touchUpInside)
        
        btnCreditCard.addTarget(self, action: #selector(onTapCreditCard(_:)), for: .touchUpInside)
        btnDebitCard.addTarget(self, action: #selector(onTapDebitCard(_:)), for: .touchUpInside)
        
        DispatchQueue.main.async {
            self.setupViews()
        }
        
        self.setupOrderInfo()
        
    }
    
 
    private func setupViews(){
        
        self.btnCreditCard.layer.cornerRadius = 28
        self.btnCreditCard.layer.backgroundColor = UIColor.fromRGBA(r: 19, g: 61, b: 110, a: 1).cgColor
        self.btnCreditCard.layer.borderColor =  UIColor.fromRGBA(r: 211, g: 211, b: 211, a: 0.3).cgColor
        self.btnCreditCard.layer.borderWidth = 1
        self.btnCreditCard.setTitleColor(UIColor.white, for: .normal)

        self.btnDebitCard.layer.cornerRadius = 28
        self.btnDebitCard.layer.backgroundColor = UIColor.fromRGBA(r: 249, g: 249, b: 249, a: 1).cgColor
        
        
        self.btnMakePayment.layer.cornerRadius = 28
        self.btnMakePayment.layer.backgroundColor = UIColor.fromRGBA(r: 235, g: 77, b: 77, a: 1).cgColor
        
        self.btnCancelPayment.layer.cornerRadius = 28
        self.btnCancelPayment.layer.backgroundColor = UIColor.fromRGBA(r: 235, g: 77, b: 77, a: 1).cgColor
        
        self.tabView.layer.cornerRadius = 31.5
        self.tabView.layer.backgroundColor = UIColor.fromRGBA(r: 249, g: 249, b: 249, a: 1).cgColor
        self.tabView.layer.borderColor =  UIColor.fromRGBA(r: 211, g: 211, b: 211, a: 0.5).cgColor
        self.tabView.layer.borderWidth = 1.2
        
        self.merchantView.layer.cornerRadius = 8
        self.merchantView.layer.backgroundColor = UIColor.fromRGBA(r: 249, g: 249, b: 249, a: 0.5).cgColor
       
        
        self.cardView.layer.cornerRadius = 8
        self.cardView.layer.backgroundColor = UIColor.fromRGBA(r: 249, g: 249, b: 249, a: 0.3).cgColor
        
        self.cardView.layer.borderColor =  UIColor.fromRGBA(r: 117, g: 193, b: 19, a: 1).cgColor
        self.cardView.layer.borderWidth = 2
        
        self.txtCardHolderName.borderStyle = .none
        self.configureTextField(txtField: txtCardHolderName)
        
        self.txtCardNumber.borderStyle = .none
        self.configureTextField(txtField: txtCardNumber)
        
        self.txtCardCVV.borderStyle = .none
        self.configureTextField(txtField: txtCardCVV)
        
        self.txtCardExpDate.borderStyle = .none
        self.configureTextField(txtField: txtCardExpDate)
        
    }
    
   private func configureTextField(txtField: UITextField){
        
        let lineView = UIView()
        lineView.layer.backgroundColor = UIColor.fromRGBA(r: 211, g: 211, b: 211, a: 1).cgColor
        txtField.addSubview(lineView)
        txtField.addConstraintWithFormat(formate: "H:|[v0]|", views: lineView)
        txtField.addConstraintWithFormat(formate: "V:[v0(1)]|", views: lineView)
    }
    
    
   private func setupOrderInfo(){
        
        if let order = self.requestFields{
            
            if let orderInfo = order.orderID{
                self.lblOrderInfo.text = "Order ID: \(orderInfo)"
            }
            
            if let amount = order.amount{
                self.lblAmount.text = "\(self.getCurrency())\(amount)"
            }
            
            //replace merchant name based on app ID
            if let merchantId = order.appID{
                self.lblMerchantInfo.text = "Pay to \(merchantId)"
            }
            
        }else{
            sleep(1)
            self.dismiss(animated: true) {
                self.delegate?.didFailedPayment(erro: NSError.init(domain: "Failed", code: 0, userInfo: ["reason": "Mandatory Parameters not satisfied! Please check the documentation for more details!"]))
            }
        }
        
    }
    
    private func getCurrency() -> String{
        
        if let order = self.requestFields{
            if let currency = order.currency{
                
                switch(currency){
                    
                case "INR":
                    return "₹"
                case "USD":
                    return "﹩"
                case "GBP":
                    return "￡"
                default:
                    return "₹"
                }
            }
        }

        return "₹"
    }
    
    
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - OnTap Actions
    @objc func onTapMakePayment(_ sender: UIButton){
        sender.onTapAnimation()
        self.dismiss(animated: true) {
            self.delegate?.didSuccessPayment(paymentInfo: ["payment": "received!"])
        }
    }
    
    @objc func onTapCancelPayment(_ sender: UIButton){
        sender.onTapAnimation()
        self.dismiss(animated: true) {
            self.delegate?.didFailedPayment(erro: NSError.init(domain: "Failed", code: 0, userInfo: ["reason": "Canceled By User"])) 
        }
    }
    
    
    @objc func onTapCreditCard(_ sender: UIButton){
        sender.onTapAnimation()
        
        self.btnCreditCard.layer.cornerRadius = 28
        self.btnCreditCard.layer.backgroundColor = UIColor.fromRGBA(r: 19, g: 61, b: 110, a: 1).cgColor
        self.btnCreditCard.layer.borderColor =  UIColor.fromRGBA(r: 211, g: 211, b: 211, a: 0.3).cgColor
        self.btnCreditCard.layer.borderWidth = 1
        sender.setTitleColor(UIColor.white, for: .normal)
        self.btnDebitCard.layer.cornerRadius = 28
        self.btnDebitCard.layer.backgroundColor = UIColor.fromRGBA(r: 249, g: 249, b: 249, a: 1).cgColor
        self.btnDebitCard.layer.borderWidth = 0
        self.btnDebitCard.setTitleColor(UIColor.darkGray, for: .normal)

    }
    
    @objc func onTapDebitCard(_ sender: UIButton){
        sender.onTapAnimation()
        
        self.btnDebitCard.layer.cornerRadius = 28
        self.btnDebitCard.layer.backgroundColor = UIColor.fromRGBA(r: 19, g: 61, b: 110, a: 1).cgColor
        self.btnDebitCard.layer.borderColor =  UIColor.fromRGBA(r: 211, g: 211, b: 211, a: 0.3).cgColor
        self.btnDebitCard.layer.borderWidth = 1
         sender.setTitleColor(UIColor.white, for: .normal)
        
        self.btnCreditCard.layer.cornerRadius = 28
        self.btnCreditCard.layer.backgroundColor = UIColor.fromRGBA(r: 249, g: 249, b: 249, a: 1).cgColor
        self.btnCreditCard.layer.borderWidth = 0
        self.btnCreditCard.setTitleColor(UIColor.darkGray, for: .normal)

        
    }

}

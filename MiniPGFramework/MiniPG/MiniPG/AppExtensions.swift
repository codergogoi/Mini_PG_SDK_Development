//
//  AppExtensions.swift
//  MiniPG
//
//  Created by Gogoi on 31/08/2018.
//  Copyright © 2018 Jayanta Gogoi. All rights reserved.
//

import UIKit

extension UIView{
    
    func shakeWarning(){
        
        DispatchQueue.main.async {
            
            let anim = CAKeyframeAnimation(keyPath: "position.x")
            anim.values = [ 0.0, 20.0, -20.0, 10.0, 0.0];
            anim.keyTimes = [0.1,0.3,0.6,0.9,1.2]
            anim.duration = 0.3;
            anim.isAdditive = true;
            self.layer.add(anim, forKey: "shake")
        }
        
    }
    
    func addConstraintWithFormat(formate: String, views: UIView...){
        
        var viewDiectionary = [String: UIView]()
        
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewDiectionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutFormatOptions(), metrics: nil, views: viewDiectionary))
        
    }
    
    
}

extension UIColor{
    
    class func fromRGBA(r: Float, g: Float, b: Float,a: Float) -> UIColor{
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
    }
}

extension UIButton{
    
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

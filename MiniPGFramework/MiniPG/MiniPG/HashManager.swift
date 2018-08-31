//
//  HashManager.swift
//  MiniPG
//
//  Created by Gogoi on 23/07/2018.
//  Copyright © 2018 Jayanta Gogoi. All rights reserved.
//

import Foundation

class HashManager : NSObject{

    var hashURL: String?
    
    func initWithURL(url: String){
        self.hashURL = url
    }
    
    func generateHash(_ hashParams: [String: Any], handler: @escaping(_ response: [String: Any]?,_ error: NSError?) -> ()){
        sleep(2)
        let sampleresponse = ["signature": "\(self.hashURL!)"]
        handler(sampleresponse, nil)
        
    }
    
    
}

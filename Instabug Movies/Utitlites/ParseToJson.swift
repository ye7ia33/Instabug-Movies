//
//  ParseToJson.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/22/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import Foundation


struct JsonHandler {
    static func jsonToNSData(json: [String : AnyObject]) -> Data?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as Data
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    
    
    
    
    
}

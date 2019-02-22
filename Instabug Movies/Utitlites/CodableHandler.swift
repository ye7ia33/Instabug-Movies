
//  CodableHandler.swift
//  Created by Yahia El-Dow on
//  Copyright © 2019 Yahia El-Dow. All rights reserved.

import UIKit

struct CodableHandler {
    static func decode<T : Decodable>(_ type: T.Type, from objectData : Data) -> Any?
    {
        do {
            let jsonDecoder = JSONDecoder()
            let contactModel = try jsonDecoder.decode( type,from: objectData )
            return contactModel
        }catch let caught as NSError {
            print(caught)
            return nil
        }
    }
    
    static func encode<T : Encodable>(_ type: T) -> AnyObject?
    {
        do{
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(type)
            let jsonEncode =  try JSONSerialization.jsonObject(with: jsonData)
            return jsonEncode as AnyObject
        }catch let caught as NSError {
            print(caught)
            return nil
        }
        
        
        
    }
    
    
}

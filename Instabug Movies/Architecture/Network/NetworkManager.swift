//
//  Network.swift
//  Instabug-Movies
//
//  Created by Yahia El-Dow on 2/21/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import Foundation
enum HttpMethodTyppe : String {
    case GET = "GET"
    case Post = "POST"
}

class NetworkManager : NSObject {
 
    static let shared : NetworkManager = {
        let netManag = NetworkManager()
        return netManag
    }()
    var config : URLSessionConfiguration!
    var session : URLSession!
    var api_queryItem : URLQueryItem!
    private let api_key  = "acea91d2bff1c53e6604e4985b6989e2"
    
    private override init() {
        self.config = URLSessionConfiguration.default
        self.session = URLSession(configuration: self.config)
        self.api_queryItem = URLQueryItem.init(name: "api_key", value: api_key)
    }

    
    func connection(stringUrl : String ,
                    urlQueryItems: [String : String] = [:] ,
                    httpMethod : HttpMethodTyppe = HttpMethodTyppe.GET ,
                    paramters : [String : AnyObject] = [:] ,
                    Result:@escaping(_ jsonData : Any? ,_ statusCode : Int? , _ errorMessage : String?)->()) {

        
        var uRLQueryItems = [URLQueryItem]()
        //TODO: adding the API KEY
        uRLQueryItems.append(self.api_queryItem)
        //TODO: quryItems LOOPING then append QUERY ITEMS
        for (key,value) in urlQueryItems {
            uRLQueryItems.append(URLQueryItem(name: key, value: value))
        }
    
        var urlComponent = URLComponents(string: stringUrl)
        urlComponent?.queryItems = uRLQueryItems
        let url = urlComponent?.url ?? URL(string: stringUrl)

        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
       
        let task = self.session!.dataTask(with: request) { (data , response , error) in
           
           var statusCode = -1
            guard let unwrappedData = data else {
                Result(nil , statusCode , error?.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse { statusCode = httpResponse.statusCode }
            do {
            let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers)
                Result(json , statusCode  , error?.localizedDescription)
            } catch {
                Result(nil , statusCode , error.localizedDescription)
                print("json error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

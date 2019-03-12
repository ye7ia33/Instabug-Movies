//
//  Network.swift
//  Instabug-Movies
//
//  Created by Yahia El-Dow on 2/21/19.
//  Copyright © 2019 Instabug. All rights reserved.
//
import UIKit
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
                    Result:@escaping(_ jsonData : Any?)->()) {

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
                let errMessage = error?.localizedDescription ?? "can`t load data"
                self.hitErrorToUser(errMessage: errMessage)
                Result(nil)
                return
            }
            if let httpResponse = response as? HTTPURLResponse { statusCode = httpResponse.statusCode }
            do {
            let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers)
                
                if statusCode != 200 {
                    let errMessage = self.errorHandleMessage(errorCode: statusCode)
                    self.hitErrorToUser(errMessage: errMessage)
                    Result(nil)
                    return
                }
                Result(json)
            } catch {
                self.hitErrorToUser(errMessage: "Error try again")
                Result(nil)
                print("json error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    
    
    
    
 private  func errorHandleMessage (errorCode : Int)-> String {
        switch errorCode {
            case 401:
                return "Invalid API key."
            case 404:
                return "The resource you requested could not be found."
            default:
                return ""
        }
    
    }
    
    
    
 private func hitErrorToUser(errMessage  : String ){
        
        DispatchQueue.main.async {
            if let vc = UIApplication.shared.keyWindow?.rootViewController {
                var topController =  vc
                while (topController.presentedViewController != nil) {
                    topController = topController.presentedViewController!
                }
                topController.showToast(message: errMessage)
            }
            
        }
    }
    
}


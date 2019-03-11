//
//  MovieAPIManager.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/24/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

class MovieAPIManager: NSObject {
    
    
    class func feachMoviesFromServer(page_number : Int ,   Result:@escaping(_ moviesData : [Movie]? ,_ page_number : Int? , _ total_pages : Int? )->() ){

        let urlQueryItems = ["page" : "\(page_number + 1)"]
        let httpMethod = HttpMethodTyppe.GET
        
        NetworkManager.shared.connection(stringUrl: Constant.baseURL ,
                                         urlQueryItems:urlQueryItems,
                                         httpMethod: httpMethod , Result: {(result) in
                                            
            if result == nil {
                Result(nil , nil , nil)
                return
            }
          
            
            guard let jsonData = result as? [String : AnyObject] else {return}
            guard let page_num = jsonData["page"] as? Int else {return}
            guard let total_pages = jsonData["total_pages"] as? Int else {return}
            
            if let jsonMoviesArray = jsonData["results"] as? NSArray {
                var moviesModelArray = [Movie]()
                for movie in jsonMoviesArray {
                    if movie is [String : AnyObject] {
                        let data = JsonHandler.jsonToNSData(json: movie as! [String : AnyObject])
                        if let movieModel = CodableHandler.decode(Movie.self, from:data ?? Data()) as? Movie{
                            moviesModelArray.append(movieModel)
                        }
                    }
                }
                
                Result(moviesModelArray , page_num , total_pages)
            }
        })
    }

    
    
}

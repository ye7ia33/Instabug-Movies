//
//  MovieViewModel.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/22/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

class MovieViewModel {
    fileprivate var page_number = 1
    fileprivate var total_pages : Int!
  
    var completionHandler:(_ Result:[Movie]? )->Void = {_ in }
    var userMovie = false
    

     func getLocal_data(){
        if let userMovie = CoreDataHandler.featchData(entityName: Constant.entityMovieName) as? [[String : AnyObject]]{
            var moviesList = [Movie]()
            for movie in userMovie {
                if let movieJson = JsonHandler.jsonToNSData(json: movie) {
                    guard let movieModel = CodableHandler.decode(Movie.self, from: movieJson) as? Movie else {continue}
                    moviesList.append(movieModel)
                }
            }
            self.completionHandler(moviesList)
        }
    }
    
    func getRemote_data() {
       
    
        MovieAPIManager.feachMoviesFromServer(page_number: self.page_number) {
                    (moviesResult , page_number , total_pages) in
            self.page_number = page_number ?? 1
            self.total_pages = total_pages
            guard let listOfNewMovies = moviesResult else {
               self.completionHandler(nil)
                return
            }

            self.completionHandler(listOfNewMovies)
        }
       
    }
    
    
    
}

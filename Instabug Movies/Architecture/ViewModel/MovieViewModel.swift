//
//  MovieViewModel.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/22/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

struct MovieViewModel {
    
    
    var img_poster : String?
    var dateString : String?
    var titleString : String?
    var overViewString : String?
    var userMovie = false
    
    init(movie : Movie , isUserMovie : Bool = false) {
        self.dateString = movie.release_date
        self.titleString = movie.title
        self.overViewString = movie.overview
        self.userMovie = isUserMovie
        if movie.poster_path != nil && isUserMovie == false{
            self.img_poster = "\(Constant.imgUrl)\(movie.poster_path!)"
        }else{
            self.img_poster = movie.poster_path
        }
    }
}

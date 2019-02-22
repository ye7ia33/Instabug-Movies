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
    
     init(movie : Movie) {
        self.dateString = movie.release_date
        self.titleString = movie.title
        self.overViewString = movie.overview
        if movie.poster_path != nil {
            self.img_poster = "https://image.tmdb.org/t/p/w200\(movie.poster_path!)?1"
        }
    }
}

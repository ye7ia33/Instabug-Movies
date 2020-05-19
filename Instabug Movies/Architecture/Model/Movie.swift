//
//  Movie.swift
//  Instabug-Movies
//
//  Created by Yahia El-Dow on 2/21/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import Foundation

struct Movie : Codable {
  
    let id: Int?
    let title: String?
    let overview: String?
    let release_date: String?
    let poster_path : String?
    var isUserMovie : Bool? = false
    
    init(id : Int , title: String , overview : String , release_date : String , poster_path: String ,isUserMovie : Bool = false ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.release_date = release_date
        self.poster_path = poster_path
        self.isUserMovie = isUserMovie
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        release_date = try container.decode(String.self, forKey: .release_date)
        poster_path = try container.decode(String.self, forKey: .poster_path)
 
        if let value = try? container.decode(Int.self, forKey: .isUserMovie) {
            isUserMovie = value == 1 ? true : false
        }

    }
    
    
    
}



//
//  MovieCustomeCellCollectionViewCell.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/22/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

class MovieCustomeCell: UITableViewCell {
    
    @IBOutlet weak var m_img_poster: CustomeUIImageView!{
        didSet{
            self.m_img_poster.image = nil
        }
    }
    
    @IBOutlet weak var m_lbl_date: UILabel!{
        didSet{
            self.m_lbl_date.text = ""
        }
    }

    @IBOutlet weak var m_lbl_title: UILabel!{
        didSet{
            self.m_lbl_title.text = ""
        }
    }
    @IBOutlet weak var m_lbl_overview: UILabel!{
        didSet{
            self.m_lbl_overview.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
   
    var movieModel : Movie! {
        didSet{
            
                if self.movieModel.isUserMovie ?? false {
                    self.m_img_poster.image = UIImage.getFromDocuments(file_name: self.movieModel.poster_path ?? "" )
                }else{
                    let img_url = Constant.imgUrl + (self.movieModel.poster_path ?? "")
                    self.m_img_poster.imageFromServerURL( img_url , placeHolder: UIImage(named: "movies_defualt_img"))
                }
                
                self.m_lbl_date.text = self.movieModel.release_date
                self.m_lbl_title.text = self.movieModel.title
                self.m_lbl_overview.text = self.movieModel.overview
            
        }
   
    }
    
    
}




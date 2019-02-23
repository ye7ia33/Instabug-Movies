//
//  MovieCustomeCellCollectionViewCell.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/22/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

class MovieCustomeCell: UITableViewCell {
    
    @IBOutlet weak var m_img_poster: UIImageView!
    
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
 
    
    var movieViewModel : MovieViewModel! {
        didSet{
            if movieViewModel.userMovie {
                self.m_img_poster.image = UIImage.getFromDocuments(file_name: self.movieViewModel.img_poster ?? "" )
            }else{
                self.m_img_poster.imageFromServerURL(self.movieViewModel.img_poster ?? "" , placeHolder: UIImage(named: "movies_defualt_img"))
            }

            self.m_lbl_date.text = self.movieViewModel.dateString
            self.m_lbl_title.text = self.movieViewModel.titleString
            self.m_lbl_overview.text = self.movieViewModel.overViewString
        }
    }
    
    
}




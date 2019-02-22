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
            self.m_img_poster.imageFromServerURL(self.movieViewModel.img_poster ?? "" , placeHolder: UIImage(named: "movies_defualt_img"))
            self.m_lbl_date.text = self.movieViewModel.dateString
            self.m_lbl_title.text = self.movieViewModel.titleString
            self.m_lbl_overview.text = self.movieViewModel.overViewString
        }
    }
    
    
}




let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error?.localizedDescription ?? "falid Error")")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

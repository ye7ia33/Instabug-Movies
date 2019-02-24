//
//  UIImageView+Extension.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/22/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class  CustomeUIImageView : UIImageView {

    func imageFromServerURL(_ imageURLString: String, placeHolder: UIImage?) {
   
        let url_encoded = imageURLString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)

        if let cachedImage = imageCache.object(forKey: NSString(string: url_encoded ?? "")) {
            self.image = cachedImage
            return
        }
        self.image = placeHolder

        if let url = URL(string: url_encoded ?? "") {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error?.localizedDescription ?? "falid Error")")
                    DispatchQueue.main.async { self.image = placeHolder }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: url_encoded ?? ""))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

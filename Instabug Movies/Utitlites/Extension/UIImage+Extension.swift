//
//  UIImage+Extension.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/23/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                print(fileURL)
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
    
   static func getFromDocuments(file_name : String) -> UIImage?{
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(file_name)
            return UIImage(contentsOfFile: imageURL.path) ?? UIImage(named: "movies_defualt_img")
        
        }
        return UIImage(named: "movies_defualt_img")
    }
}

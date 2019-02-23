//
//  NewMoviesVC.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/22/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit
import Photos
import Foundation
import CoreData

class NewMoviesVC: UIViewController {
    @IBOutlet weak var newMovie_poster: UIImageView!
    @IBOutlet weak var newMovie_btn_SelectPoster: UIButton!{
        didSet{
            self.newMovie_btn_SelectPoster.layer.masksToBounds = true
            self.newMovie_btn_SelectPoster.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var newMovie_txt_title: UITextField!
    @IBOutlet weak var newMovie_txt_date: UITextField!
    @IBOutlet weak var newMovie_txt_overView: UITextView!{
        didSet{
            self.newMovie_txt_overView.text = ""
            self.newMovie_txt_overView.layer.borderWidth = 1
        }
    }

    
    @IBOutlet weak var newMovie_btn_save: UIButton!{
        didSet{
        self.newMovie_btn_save.layer.masksToBounds = true
        self.newMovie_btn_save.layer.cornerRadius = 15
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
   
        
        
}
    
    @IBAction func selectPosterButtonAction(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            NSLog("Will request authorization")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                   self.openPhotos()
                }
            })
            
        } else {
            DispatchQueue.main.async(execute: {
                self.openPhotos()
            })
        }
        
     
    }
    
    private func openPhotos(){
        DispatchQueue.main.async(execute: {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = false
            self.present(photoPicker, animated: true)
        })
    }
    

    @IBAction func saveMoviesButtonAction(_ sender: Any) {
        
        guard self.newMovie_poster.image != nil else {return}
        let title = self.newMovie_txt_title.text
        let date = self.newMovie_txt_date.text
        let overView = self.newMovie_txt_overView.text
        let poster_name: Int = Int(arc4random()) * Int(arc4random())
        
        let movieModel = Movie.init(id: 0, title: title ,
                                    overview: overView ,
                                    release_date: date,
                                    poster_path: "\(poster_name)" )

        
        if CoreDataHandler.inset(entityName: Constant.entityMovieName ,
                                 entityData: CodableHandler.encode(movieModel) as! [String : AnyObject]){
            self.newMovie_poster.image?.saveToDocuments(filename: "\(poster_name)")
            
            self.navigationController?.popViewController(animated: true)

        }
    }
    

}

extension NewMoviesVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        self.newMovie_poster.image = image
    }

    
    
}

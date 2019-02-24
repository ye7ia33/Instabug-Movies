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
    

    fileprivate var picker_movieRelaseDate : UIDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(keyboardWillHide))
        self.view.addGestureRecognizer(tap)

}
    
  
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }
    
    
    
    
    @IBAction func selectPosterButtonAction(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            print("Will request authorization")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                   self.openPhotos()
                }else{
                    self.askUserToAuthrizedPhotos()
                }
            })
            
        } else {
            DispatchQueue.main.async(execute: {
                self.openPhotos()
            })
        }
        
     
    }
   
    private func askUserToAuthrizedPhotos(){
        let alert = UIAlertController(title: "!",
                                      message: "This app is not authorized to use Photo Libary.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

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

        if title?.count == 0 {
            let alert = UIAlertController(title: "!", message: "Enter Movie Title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if date?.count == 0 {
            let alert = UIAlertController(title: "!", message: "Enter Movie Relase Date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if overView?.count == 0 {
            let alert = UIAlertController(title: "!", message: "Enter Movie overview", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        let number: Int = 10
        let poster_name = Int(arc4random_uniform(UInt32(number)))
        
        let movieModel = Movie.init(id: 0,
                                    title: title ?? "",
                                    overview: overView ?? "",
                                    release_date: date ?? "",
                                    poster_path: "\(poster_name)" ,
                                    isUserMovie : true
                                    )

        
        if CoreDataHandler.inset(entityName: Constant.entityMovieName ,
                                 entityData: CodableHandler.encode(movieModel) as! [String : AnyObject])
        {
            self.newMovie_poster.image?.saveToDocuments(filename: "\(poster_name)")
//            self.showToast(message: "Movie Saved")
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "!", message: "Movie not Save", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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





extension NewMoviesVC : UITextFieldDelegate {
    
    private var pickerToolBar : UIToolbar {
        let doneButton = UIBarButtonItem(title: "Select", style: .plain, target: self,
                                         action: #selector(pickerView_toolBarAction_done(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,  action: #selector(pickerView_toolBarAction_cancel(sender:)))
        
        doneButton.tintColor = .white
        cancelButton.tintColor = .white
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = .black
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        return toolBar
    }
    @IBAction func pickerView_toolBarAction_done (sender : AnyObject){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        let local =  Locale(identifier: "en_US")
        formatter.locale = local
        
        self.newMovie_txt_date.text = formatter.string(from: picker_movieRelaseDate.date)
        self.view.endEditing(true)
    }
    @IBAction func pickerView_toolBarAction_cancel (sender : AnyObject){
       self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.newMovie_txt_date {
            picker_movieRelaseDate.datePickerMode = .date
            textField.inputAccessoryView = self.pickerToolBar
            textField.inputView = picker_movieRelaseDate
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

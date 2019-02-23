//
//  UserMoviesVC.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/23/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit
import CoreData

class UserMoviesVC: UIViewController {
    fileprivate let cell_identifier = "MovieCellIdentifier"
    fileprivate var selectedIndexPath : IndexPath!
    fileprivate var fixedRowHeight : CGFloat = 216.0
    fileprivate var serverIsConnect = false
    @IBOutlet weak var myMovies_tableView: UITableView!{
        didSet{
            let movieNib = UINib(nibName: "MovieCustomeCell", bundle: nil)
            self.myMovies_tableView.register(movieNib, forCellReuseIdentifier: cell_identifier)
            self.myMovies_tableView.estimatedRowHeight = self.fixedRowHeight
            
        }
    }
    
    fileprivate var moviesList = [MovieViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    if let userMovie = CoreDataHandler.featchData(entityName: Constant.entityMovieName) as? [[String : AnyObject]]{
        for movie in userMovie {
            if let movieJson = JsonHandler.jsonToNSData(json: movie) {
                let movieModel = CodableHandler.decode(Movie.self, from: movieJson)
                let viewModel = MovieViewModel.init(movie: movieModel as! Movie , isUserMovie: true)
                self.moviesList.append(viewModel)
            }
        }
         }
    }
}

extension UserMoviesVC  : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! MovieCustomeCell
        let movieViewModel = self.moviesList[row]
        cell.movieViewModel = movieViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndexPath == indexPath &&
            //            Check if cell open
            tableView.cellForRow(at: indexPath)?.frame.height == fixedRowHeight{
            return UITableView.automaticDimension
        }
        return fixedRowHeight
    }
}

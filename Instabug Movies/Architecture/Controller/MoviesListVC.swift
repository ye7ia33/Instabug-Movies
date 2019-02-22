//
//  ViewController.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/21/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

class MoviesListVC: UIViewController {
    fileprivate let cell_identifier = "MovieCellIdentifier"
    fileprivate var page_number = 0
    fileprivate var total_pages : Int!
    fileprivate var selectedIndexPath : IndexPath!
    fileprivate var fixedRowHeight : CGFloat = 216.0
    fileprivate var serverIsConnect = false
    @IBOutlet weak var movies_tableView: UITableView!{
        didSet{
            let movieNib = UINib(nibName: "MovieCustomeCell", bundle: nil)
            self.movies_tableView.register(movieNib, forCellReuseIdentifier: cell_identifier)
        }
    }
    
    fileprivate var moviesList = [MovieViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.feachMoviesFromServer()
    }
    
    
    
    
    fileprivate func feachMoviesFromServer(){
        
        // check if user not load all movies from server
        if self.total_pages != nil && self.total_pages <= self.moviesList.count {return}
        // check if user not connect to server
        if self.serverIsConnect {return}
        // closing featching data from server
        self.serverIsConnect = true
        
        let url = "http://api.themoviedb.org/3/discover/movie"
        let urlQueryItems = ["page" : "\(page_number + 1)"]
        let httpMethod = HttpMethodTyppe.GET
        
        NetworkManager.shared.connection(stringUrl: url , urlQueryItems:urlQueryItems, httpMethod: httpMethod , Result: {(result , statusCode , errMessage) in
            
            if errMessage != nil {return}
            guard let jsonData = result as? [String : AnyObject] else {return}
            if let page_num = jsonData["page"] as? Int { self.page_number = page_num }
            if let total_pages = jsonData["total_pages"] as? Int { self.total_pages = total_pages }
            if let moviesArray = jsonData["results"] as? NSArray {
                for movie in moviesArray {
                    let data = JsonHandler.jsonToNSData(json: movie as AnyObject)
                    if let movieModel = CodableHandler.decode(Movie.self, from:data ?? Data()) as? Movie{
                        let movieViewModel = MovieViewModel(movie: movieModel)
                        self.moviesList.append(movieViewModel)
                    }
                }
                DispatchQueue.main.async {
                    self.movies_tableView.reloadData()
                    self.serverIsConnect = false
                }
                
            }
            
        })
    }

}



extension MoviesListVC  : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! MovieCustomeCell
        
        let movieViewModel = self.moviesList[row]
        cell.movieViewModel = movieViewModel
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        tableView.reloadRows(at: [indexPath], with: .none)
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


extension MoviesListVC : UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= (fixedRowHeight * 2) {
            //TODO: LOAD MORE 
            self.feachMoviesFromServer()
        }
    }
}

//
//  ViewController.swift
//  Instabug Movies
//
//  Created by Yahia El-Dow on 2/21/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

class MoviesListVC: UIViewController {
    @IBOutlet weak var loaderViewController: UIView! {
        didSet{
            self.loaderViewController.isHidden = true
        }
    }
    fileprivate let cell_identifier = "MovieCellIdentifier"

    fileprivate var selectedIndexPath : IndexPath!
    fileprivate var fixedRowHeight : CGFloat = 120.0
    fileprivate var serverIsConnect = false
    @IBOutlet weak var movies_tableView: UITableView!{
        didSet{
            let movieNib = UINib(nibName: "MovieCustomeCell", bundle: nil)
            self.movies_tableView.register(movieNib, forCellReuseIdentifier: cell_identifier)
            self.movies_tableView.estimatedRowHeight = self.fixedRowHeight

        }
    }
    
    fileprivate var refreshControl = UIRefreshControl()
    
    
    var viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "movieListView"
        self.movies_tableView.accessibilityIdentifier = "movies_tableView"

        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .allEvents)
        self.movies_tableView.insertSubview(refreshControl , at: 0)

        self.featchMoviesData()
        self.viewModel.completionHandler = {
            DispatchQueue.main.async {
                self.movies_tableView.reloadData()
                self.loaderViewController.isHidden = true
                self.refreshControl.endRefreshing()
            }
            self.serverIsConnect = !self.serverIsConnect
    }
    
}

    
    @objc private func pullToRefresh(){
        if viewModel.moviesList.count == 0 {
            self.featchMoviesData()
            return
        }
        self.refreshControl.endRefreshing()
    }
     fileprivate func featchMoviesData(){
//         check if user not connect to server
        if self.serverIsConnect {return}
        self.serverIsConnect = !self.serverIsConnect
        self.viewModel.getRemote_data()
        
    }
    
}



extension MoviesListVC  : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return viewModel.moviesList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! MovieCustomeCell
        let movieModel = viewModel.moviesList[row]
        cell.movieModel = movieModel
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
        // Check if cell open
            tableView.cellForRow(at: indexPath)?.frame.height == fixedRowHeight
        {
            return UITableView.automaticDimension
        }
        return fixedRowHeight
    }
}


extension MoviesListVC : UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= (fixedRowHeight * 2) &&
            maximumOffset > self.view.frame.size.height{
            //TODO: LOAD MORE 
             self.featchMoviesData()
        }
    }
}

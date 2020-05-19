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
    fileprivate var fixedRowHeight : CGFloat = 216.0
    fileprivate var serverIsConnect = false
    @IBOutlet weak var movies_tableView: UITableView!{
        didSet{
            self.movies_tableView.accessibilityIdentifier = "movies_tableView"
            let movieNib = UINib(nibName: "MovieCustomeCell", bundle: nil)
            self.movies_tableView.register(movieNib, forCellReuseIdentifier: Constant.movie_cell_identifier)
        }
    }
    fileprivate var refreshControl = UIRefreshControl()


    let viewModel = MovieViewModel()
   
   private var dataSource_and_delegate : MovieTableViewDelegateDataSource = {
        let fixedRowHeight : CGFloat = 120.0
        let dataSource_delegate = MovieTableViewDelegateDataSource( fixedRowHeight: fixedRowHeight)
        return dataSource_delegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "movieListView"

        // TABLEVIEW DATA SOURCE
        self.movies_tableView.dataSource = dataSource_and_delegate
        self.movies_tableView.delegate = dataSource_and_delegate
        
        //  REFRESH CONTROLLER
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .allEvents)
        self.movies_tableView.insertSubview(refreshControl , at: 0)
       
        // CALL BACK
        self.viewModel.completionHandler = {
            moviesListArray in
            if moviesListArray == nil {return}
            DispatchQueue.main.async {
                self.dataSource_and_delegate.moviesList.append(contentsOf: moviesListArray!)
                self.movies_tableView.reloadData()
                self.loaderViewController.isHidden = true
                self.refreshControl.endRefreshing()
            }
            self.serverIsConnect = !self.serverIsConnect
        }
        self.featchMoviesData()
    
        dataSource_and_delegate.loadMoreData = {
            self.featchMoviesData()
        }
}

    
    @objc private func pullToRefresh(){
        if self.dataSource_and_delegate.moviesList.count == 0 {
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




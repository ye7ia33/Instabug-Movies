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

    fileprivate var selectedIndexPath : IndexPath!

    fileprivate var serverIsConnect = false
    @IBOutlet weak var myMovies_tableView: UITableView!{
        didSet{
            self.myMovies_tableView.accessibilityIdentifier = "myMovies_tableView"
            let movieNib = UINib(nibName: "MovieCustomeCell", bundle: nil)
            self.myMovies_tableView.register(movieNib, forCellReuseIdentifier: Constant.movie_cell_identifier)
        }
    }
    
    var viewModel = MovieViewModel()

    private var dataSource_and_delegate : MovieTableViewDelegateDataSource = {
        let fixedRowHeight : CGFloat = 120.0
        let dataSource_delegate = MovieTableViewDelegateDataSource( fixedRowHeight: fixedRowHeight)
        return dataSource_delegate
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TABLEVIEW DATA SOURCE

        self.myMovies_tableView.dataSource = dataSource_and_delegate
        self.myMovies_tableView.delegate = dataSource_and_delegate
        
        self.viewModel.completionHandler = {
            moviesListArray in
            if moviesListArray == nil {return}
            self.dataSource_and_delegate.moviesList.append(contentsOf: moviesListArray!)
            self.myMovies_tableView.reloadData()
        }
       
        self.viewModel.getLocal_data()
  
    }
}

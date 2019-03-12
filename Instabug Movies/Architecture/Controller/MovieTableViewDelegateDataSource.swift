//
//  TestVC.swift
//  Instabug Movies
//
//  Created by El-Dow iMac on 3/11/19.
//  Copyright © 2019 Instabug. All rights reserved.
//

import UIKit

class MovieTableViewDelegateDataSource : NSObject , UITableViewDataSource  {
   fileprivate var cellIdentifier : String!
   fileprivate var fixedRowHeight : CGFloat!
   fileprivate var selectedIndexPath : IndexPath!
   var moviesList = [Movie]()
   var loadMoreData : ()->() = {}
    
    init(cellIdentifier : String = Constant.movie_cell_identifier , fixedRowHeight : CGFloat) {
        self.cellIdentifier = cellIdentifier
        self.fixedRowHeight = fixedRowHeight
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return moviesList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier , for: indexPath) as! MovieCustomeCell
            cell.movieModel = moviesList[row]
        return cell
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

extension MovieTableViewDelegateDataSource : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}


extension MovieTableViewDelegateDataSource : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= (fixedRowHeight * 2) &&
            maximumOffset > scrollView.frame.size.height{
            //TODO: LOAD MORE
            self.loadMoreData()
        }

    }
}

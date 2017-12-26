//
//  LandingViewModel.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation

protocol LandingViewModelType {
    
    var id: Int { get }
    var tableViewFeeds: Array<FeedViewModel>  { get set }
    var collectionViewFeeds: Array<FeedViewModel> { get set }
}

struct LandingViewModel: LandingViewModelType {
    
    let id: Int
    var tableViewFeeds = Array<FeedViewModel>()
    var collectionViewFeeds = Array<FeedViewModel>()
    
    init(_ obj: Landing) {
        self.id = obj.id
        
        for item in obj.feeds {
            let feed = FeedViewModel(item)
            self.tableViewFeeds.append(feed)
        }
        
        for item in obj.feeds.filter({ $0.isFavorite == true }) {
            let feed = FeedViewModel(item)
            self.collectionViewFeeds.append(feed)
        }
    }
}

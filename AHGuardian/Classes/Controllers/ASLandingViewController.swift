//
//  ASLandingViewController.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation
import Alamofire
import AsyncDisplayKit

final class ASLandingViewController: ASViewController<ASDisplayNode> {
    
    fileprivate typealias FeedsCallback = (_ model: LandingViewModelType) -> ()
    fileprivate var landingViewModel: LandingViewModelType?
    fileprivate var tableDataProvider: ASFeedTableDataProvider?
    fileprivate var collectionDataProvider: FeedCollectionDataProvider?
    fileprivate let landingView = ASLandingView()
    fileprivate var timer: DispatchSourceTimer?
    fileprivate var tuple = (pageSize: 10, loading: false)

    deinit {
        self.stopTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseConfig()
    }
}

//MARK: - Private Methods -
extension ASLandingViewController {
    
    fileprivate func baseConfig() {
        self.view = landingView
        self.title = "News Feed Async"
        
        configTableDataProvider()
        configCollectionDataProvider()
        setupInitialState()
        startTimer()
    }
    
    fileprivate func setupInitialState() {
        
        if APIHelper.isConnected() {
            getFeeds(showProgressHUD: true) { [weak self] viewModel in
                self?.update(with: viewModel)
            }
        } else {
            guard let landing = DBHelper.getLanding() else { return }
            let viewModel = LandingViewModel(landing)
            update(with: viewModel)
        }
    }
    
    fileprivate func configureNodes() {

    }
    
    fileprivate func configTableDataProvider() {
        tableDataProvider = ASFeedTableDataProvider(with: landingView.tableNode)
        tableDataProvider?.didSelectPin = didSelectTablePin
        tableDataProvider?.loadMore = loadMore
    }
    
    fileprivate func configCollectionDataProvider() {
        collectionDataProvider = FeedCollectionDataProvider(with: landingView.collectionView)
        collectionDataProvider?.didSelectPin = didSelectCollectionPin
    }

    fileprivate func update(with  viewModel: LandingViewModelType) {
        landingViewModel = viewModel
        
        tableDataProvider?.updateTableNode(with: viewModel.tableViewFeeds)
        collectionDataProvider?.updateCollectionView(with: viewModel.collectionViewFeeds)
    }
}

//MARK: - Callbacks -
extension ASLandingViewController {
    
    fileprivate func didSelectTablePin(_ item: FeedViewModelType) {
        
        //update local feed
        DBHelper.updateFavoriteFeed(item)
        
        if item.isSelected {
            collectionDataProvider?.insertNewItemInCollectionView(with: item)
        } else {
            collectionDataProvider?.deleteItemFromCollectionView(with: item)
        }
    }
    
    fileprivate func didSelectCollectionPin(_ item: FeedViewModelType) {
        
        //update local feed
        DBHelper.updateFavoriteFeed(item)

        // delete collection item
        collectionDataProvider?.deleteItemFromCollectionView(with: item)
        
        // update correct table view item
        guard let row = landingViewModel?.tableViewFeeds.index(where: { $0.id == item.id }) else { return }
        tableDataProvider?.updateSelectButton(with: row, state: false)
    }

    fileprivate func loadMore() {
        if !tuple.loading {
            tuple.pageSize += 10
            tuple.loading = true
            landingView.activityIndicatorView.startAnimating()
            landingView.tableNode.view.tableFooterView?.isHidden = false
            
            getFeeds { [weak self] viewModel in
                self?.tuple.loading = (viewModel.tableViewFeeds.count == 0)
                self?.landingView.activityIndicatorView.stopAnimating()
                self?.landingView.tableNode.view.tableFooterView?.isHidden = true

                if viewModel.tableViewFeeds.count > 0 {
                    self?.landingViewModel?.tableViewFeeds += viewModel.tableViewFeeds
                    self?.tableDataProvider?.insertNewItemsInTableNode(with: viewModel.tableViewFeeds)
                }
            }
        }
    }
}

//MARK: - Timer -
extension ASLandingViewController {
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.arohak.AHNewsFeed")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(30))
        timer!.setEventHandler { [weak self] in
            self?.checkNewFeeds()
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

//MARK: - API -
extension ASLandingViewController {
    
    private func checkNewFeeds() {
        NewsFeedEndpoint.getFeeds(showProgressHUD: false, pageSize: 1) { [weak self] data in
            let landing = Landing(data: data)
            guard let currentLanding = DBHelper.getLanding() else { return }
            
            if currentLanding.total != landing.total {
                self?.tuple = (pageSize: 10, loading: false)
                self?.setupInitialState()
            }
        }
    }
    
    private func getFeeds(showProgressHUD: Bool = false, callback: @escaping FeedsCallback) {
        NewsFeedEndpoint.getFeeds(showProgressHUD: showProgressHUD, pageSize: tuple.pageSize) { [weak self] data in
            let obj = Landing(data: data)
            
            //putt in store
            DBHelper.storeLanding(obj)
            
            //get from store
            guard let landing = DBHelper.getLanding((self?.tuple.pageSize)!) else { return }
            let viewModel = LandingViewModel(landing)
            callback(viewModel)
        }
    }
}


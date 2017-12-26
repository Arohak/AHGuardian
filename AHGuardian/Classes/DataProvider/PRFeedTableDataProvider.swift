//
//  FeedTableDataProvider.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

final class PRFeedTableDataProvider: NSObject {
    
    var items:[FeedViewModelType] = []
    var tableView: UITableView?
    var didSelectPin: ((_ item: FeedViewModelType) -> ())?
    var loadMore: ((_ index: Int) -> ())?

    // Pre-Fetching Queue
    fileprivate let imageLoadQueue = OperationQueue()
    fileprivate var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    
    required init(with tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.prefetchDataSource = self
    }
}

extension PRFeedTableDataProvider: TableDataProviderProtocol, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedTableViewCell.self)
        let item = self.items[indexPath.row]
        cell.cellContentView.selectButton.addTarget(self, action: #selector(selectButtonAction), for: .touchUpInside)
        cell.cellContentView.selectButton.tag = indexPath.row
        cell.setup(with: item)
        
        if let imageLoadOperation = imageLoadOperations[indexPath], let image = imageLoadOperation.image {
            cell.cellContentView.thumbImageView.setRoundedImage(image)
        } else {
            let imageLoadOperation = ImageLoadOperation(url: item.image)
            imageLoadOperation.completionHandler = { [weak self] (image) in
                guard let strongSelf = self else { return }
                cell.cellContentView.thumbImageView.setRoundedImage(image)
                strongSelf.imageLoadOperations.removeValue(forKey: indexPath)
            }
            imageLoadQueue.addOperation(imageLoadOperation)
            imageLoadOperations[indexPath] = imageLoadOperation
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMore?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imageLoadOperation = imageLoadOperations[indexPath] else { return }
        
        imageLoadOperation.cancel()
        imageLoadOperations.removeValue(forKey: indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = imageLoadOperations[indexPath] { return }
            
            let item = self.items[indexPath.row]
            let imageLoadOperation = ImageLoadOperation(url: item.image)
            imageLoadQueue.addOperation(imageLoadOperation)
            imageLoadOperations[indexPath] = imageLoadOperation
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageLoadOperation = imageLoadOperations[indexPath] else { return }
            
            imageLoadOperation.cancel()
            imageLoadOperations.removeValue(forKey: indexPath)
        }
    }
}

extension PRFeedTableDataProvider {
    
    @objc func selectButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        items[sender.tag].isSelected = sender.isSelected
        let item = items[sender.tag]
        
        didSelectPin?(item)
    }
}

//MARK: - Update -
extension PRFeedTableDataProvider {
    
    func updateTableView(with items: [FeedViewModelType]) {
        self.items = items
        self.tableView?.reloadData()
    }
    
    func insertNewItemsInTableView(with items: [FeedViewModelType]) {
        self.items += items
        
        let count = self.items.count
        var indexPaths = [IndexPath]()
        for row in count - 10..<count {
            let path = IndexPath(row: row, section: 0)
            indexPaths.append(path)
        }
        
        tableView?.reloadData()
    }
    
    func updateSelectButton(with index: Int, state: Bool) {
        items[index].isSelected = state
        
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableView?.cellForRow(at: indexPath) as? FeedTableViewCell
        cell?.cellContentView.selectButton.isSelected = state
    }
}

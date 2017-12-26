//
//  FeedsCollectionDataProvider.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

protocol FeedCollectionDataProviderProtocol: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    associatedtype T
    var items:[T] {get}
    weak var collectionView: UICollectionView? {get}
    
    init(with collectionView: UICollectionView)
    func updateCollectionView(with items: [T])
    func insertNewItemInCollectionView(with item: T)
    func deleteItemFromCollectionView(with item: T)
}

final class FeedCollectionDataProvider: NSObject {
    
    var items: [FeedViewModelType] = []
    weak var collectionView: UICollectionView?
    var didSelectRow: ((_ item: FeedViewModelType) -> ())?
    var didSelectPin: ((_ item: FeedViewModelType) -> ())?
    
    required init(with collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
    }
}

extension FeedCollectionDataProvider: FeedCollectionDataProviderProtocol {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FeedCollectionViewCell.self)
        let item = items[indexPath.row]
        cell.cellContentView.selectButton.addTarget(self, action: #selector(selectButtonAction), for: .touchUpInside)
        cell.cellContentView.selectButton.tag = indexPath.row
        cell.setup(with: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelectRow?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collection_height*0.9
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = min_inset
        
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}

extension FeedCollectionDataProvider {
    
    @objc func selectButtonAction(_ sender: UIButton) {
        let item = items[sender.tag]
        didSelectPin?(item)
    }
}

extension FeedCollectionDataProvider {
    
    func updateCollectionView(with items: [FeedViewModelType]) {
        self.items = items
        self.collectionView?.reloadData()
    }
    
    func insertNewItemInCollectionView(with item: FeedViewModelType) {
        self.items.append(item)
        let indexPath = IndexPath(row: self.items.count - 1, section: 0)
        self.collectionView?.insertItems(at: [indexPath])
        self.collectionView?.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    func deleteItemFromCollectionView(with item: FeedViewModelType) {
        guard let index = self.items.index(where: { $0.id == item.id }) else { return }
        self.items.remove(at: index)
        self.collectionView?.reloadData()
        
//        let indexPath = IndexPath(row: index, section: 0)
//        self.collectionView?.deleteItems(at: [indexPath])
    }
}

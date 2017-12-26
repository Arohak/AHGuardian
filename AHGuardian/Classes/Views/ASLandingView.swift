//
//  ASLandingView.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ASLandingView: UIView {

    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        view.color = .white

        return view
    }()
    
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode()
        node.view.tableFooterView = self.activityIndicatorView
        node.view.backgroundColor = bg_color
        node.view.allowsSelection = true
        node.view.separatorStyle = .singleLine
        
        return node
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.register(cellType: FeedCollectionViewCell.self)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ASLandingView: ViewConfiguration {
    
    func configureViews() {
        backgroundColor = bg_color
    }
    
    func buildViewHierarchy() {
        addSubview(collectionView)
        addSubnode(tableNode)
    }
    
    func setupConstraints() {
        collectionView.autoPinEdge(toSuperviewEdge: .top)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoSetDimension(.height, toSize: collection_height)
        
        tableNode.view.autoPinEdge(.top, to: .bottom, of: collectionView)
        tableNode.view.autoPinEdge(toSuperviewEdge: .left)
        tableNode.view.autoPinEdge(toSuperviewEdge: .right)
        tableNode.view.autoPinEdge(toSuperviewEdge: .bottom)
    }
}

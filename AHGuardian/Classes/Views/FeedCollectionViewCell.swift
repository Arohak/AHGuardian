//
//  FeedCollectionViewCell.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit
import Reusable
import PureLayout

extension FeedCollectionViewCell: Reusable { }

class FeedCollectionViewCell: UICollectionViewCell {
    
    lazy var cellContentView: FeedCollectionViewCellContentView = {
        let view = FeedCollectionViewCellContentView.newAutoLayout()

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

extension FeedCollectionViewCell: ViewConfiguration {
    
    func configureViews() {

    }
    
    func buildViewHierarchy() {
        contentView.addSubview(cellContentView)
    }
    
    func setupConstraints() {
        cellContentView.autoPinEdgesToSuperviewEdges()
    }
}

extension FeedCollectionViewCell {
    
    func setup(with item: FeedViewModelType) {
        cellContentView.setup(with: item)
    }
}

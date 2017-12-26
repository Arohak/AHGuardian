//
//  FeedTableViewCell.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit
import Reusable
import PureLayout

extension FeedTableViewCell: Reusable { }

class FeedTableViewCell: UITableViewCell {
    
    lazy var cellContentView: FeedTableViewCellContentView = {
        let view = FeedTableViewCellContentView.newAutoLayout()

        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedTableViewCell: ViewConfiguration {
    
    func configureViews() {
        selectionStyle = .none
    }
    
    func buildViewHierarchy() {
        contentView.addSubview(cellContentView)
    }
    
    func setupConstraints() {
        cellContentView.autoPinEdgesToSuperviewEdges()
    }
}

extension FeedTableViewCell {
    
    func setup(with item: FeedViewModelType) {
        cellContentView.setup(with: item)
    }
}

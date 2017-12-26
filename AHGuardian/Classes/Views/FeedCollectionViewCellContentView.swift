//
//  FeedCollectionViewCellContentView.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit
import PureLayout

final class FeedCollectionViewCellContentView: UIView {
    
    lazy var thumbImageView: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var selectButton: UIButton = {
        let view = UIButton.newAutoLayout()
        view.setBackgroundImage(UIImage(named: "img_favorit_delete"), for: .normal)

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

extension FeedCollectionViewCellContentView: ViewConfiguration {
    
    func configureViews() {
        backgroundColor = bg_color
    }
    
    func buildViewHierarchy() {
        addSubview(thumbImageView)
        addSubview(selectButton)
    }
    
    func setupConstraints() {
        let inset: CGFloat = min_inset

        thumbImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))

        selectButton.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
        selectButton.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        selectButton.autoSetDimensions(to: CGSize(width: 4*inset, height: 4*inset))
    }
}

extension FeedCollectionViewCellContentView {
    
    func setup(with item: FeedViewModelType) {
        selectButton.isSelected = item.isSelected
        thumbImageView.download(image: item.image)
    }
}


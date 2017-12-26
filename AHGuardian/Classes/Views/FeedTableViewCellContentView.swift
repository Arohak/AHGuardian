//
//  FeedTableViewCellContentView.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 15/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit
import PureLayout

final class FeedTableViewCellContentView: UIView {
    
    lazy var thumbImageView: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = table_img_height/2
        
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 16)
        view.textAlignment = .left
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.textColor = .white
        view.font = .systemFont(ofSize: 12)
        view.textAlignment = .left
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var selectButton: UIButton = {
        let view = UIButton.newAutoLayout()
        view.setBackgroundImage(UIImage(named: "img_favorit_select"), for: .normal)
        view.setBackgroundImage(UIImage(named: "img_favorit_deselect"), for: .selected)
        
        return view
    }()
    
    lazy var tagsLabel: TagsLabel = {
        let view = TagsLabel.newAutoLayout()
        
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

extension FeedTableViewCellContentView: ViewConfiguration {
    
    func configureViews() {
        backgroundColor = bg_color
    }
    
    func buildViewHierarchy() {
        addSubview(thumbImageView)
        addSubview(categoryLabel)
        addSubview(titleLabel)
        addSubview(selectButton)
        addSubview(tagsLabel)
    }
    
    func setupConstraints() {
        let inset: CGFloat = max_inset
        let width: CGFloat = table_img_height
        
        thumbImageView.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
        thumbImageView.autoPinEdge(toSuperviewEdge: .left, withInset: inset)
        thumbImageView.autoSetDimensions(to: CGSize(width: width, height: width))
        
        categoryLabel.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
        categoryLabel.autoPinEdge(.left, to: .right, of: thumbImageView, withOffset: inset)
        categoryLabel.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: categoryLabel, withOffset: inset)
        titleLabel.autoPinEdge(.left, to: .right, of: thumbImageView, withOffset: inset)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        
        selectButton.autoPinEdge(toSuperviewEdge: .top, withInset: inset/2)
        selectButton.autoPinEdge(toSuperviewEdge: .right, withInset: inset/2)
        selectButton.autoSetDimensions(to: CGSize(width: 2*inset, height: 3*inset))
        
        tagsLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: inset)
        tagsLabel.autoPinEdge(.left, to: .right, of: thumbImageView, withOffset: inset)
        tagsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        tagsLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: inset)
    }
}

extension FeedTableViewCellContentView {
    
    func setup(with item: FeedViewModelType) {
        categoryLabel.text = item.category
        titleLabel.text = item.title
        selectButton.isSelected = item.isSelected
        
        thumbImageView.download(image: item.image)
        tagsLabel.setTags(item.tags)
    }
}

//
//  ViewConfiguration.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation

protocol ViewConfiguration: class {
    
    func setupViewConfiguration()
    func configureViews()
    func setupConstraints()
    func buildViewHierarchy()
}

extension ViewConfiguration {
    
    func setupViewConfiguration() {
        configureViews()
        buildViewHierarchy()
        setupConstraints()
    }
}

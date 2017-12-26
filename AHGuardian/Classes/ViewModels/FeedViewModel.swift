//
//  FeedViewModel.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation

protocol FeedViewModelType {
    
    var id: String { get }
    var title: String { get }
    var category: String { get }
    var image: URL? { get }
    var isSelected: Bool { get set }
    var tags: Array<String> { get }
}

struct FeedViewModel: FeedViewModelType {
    
    let id: String
    let title: String
    let category: String
    let image: URL?
    var isSelected: Bool
    var tags = Array<String>()
    
    init(_ obj: Feed) {
        self.id         = obj.id
        self.title      = obj.webTitle
        self.category   = obj.pillarName + " (" + obj.sectionName + ")"
        self.image      = URL(string: obj.thumbnail)
        self.isSelected = obj.isFavorite

        for tag in title.split(separator: " ") {
            self.tags.append(String(tag))
        }
    }
}

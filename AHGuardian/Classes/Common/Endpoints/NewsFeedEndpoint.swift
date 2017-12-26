//
//  NewsFeedEndpoint.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

protocol NewsFeedEndpointProtocol {
    
    static func getFeeds(showProgressHUD: Bool, pageSize: Int, block: @escaping CompletionBlock)
}

struct NewsFeedEndpoint {
    
    enum Router {
        static let getFeeds = "/search?format=json&show-fields=thumbnail&page-size=%i"
    }
}

extension NewsFeedEndpoint : NewsFeedEndpointProtocol {
    
    static func getFeeds(showProgressHUD: Bool, pageSize: Int, block: @escaping CompletionBlock) {
        let url = String(format: Router.getFeeds, pageSize)
        APIHelper.request(.get, url, nil, showProgressHUD, completionBlock: block)
    }
}

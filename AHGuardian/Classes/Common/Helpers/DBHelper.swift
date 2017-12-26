//
//  DBHelper.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import RealmSwift

struct DBHelper {
    
    static var realm: Realm!
    static let version = ConfigHelper.getAppVersionNumber()
    static let config = Realm.Configuration(
        schemaVersion: version,
        migrationBlock: { migration, oldSchemaVersion in
    })
    
    static func updateRealmSchemaVersion() {
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
    }
    
    //MARK: - Landing -
    static func storeLanding(_ obj: Landing) {
        try! realm.write {
            let favoriteFeeds = getFavoriteFeeds()
            
            for feed in obj.feeds {
                if let findFavoriteFeed = favoriteFeeds.filter({ $0.id == feed.id }).first {
                    feed.isFavorite = findFavoriteFeed.isFavorite
                }
            }
            
            realm.add(obj, update: true)
        }
    }
    
    static func getLanding() -> Landing? {
        guard let landing = realm.objects(Landing.self).first else { return nil }
        
        return landing
    }
    
    static func getLanding(_ pageSize: Int) -> Landing? {
        guard let landing = realm.objects(Landing.self).first else { return nil }
        let feeds = Array(landing.feeds[pageSize - 10..<pageSize])
        let newLanding = Landing(id: landing.id, total: landing.total, status: landing.status, feeds: feeds)
        
        return newLanding
    }
    
    //MARK: - Feed -
    static func getFavoriteFeeds() -> Results<Feed> {
        let feeds = realm.objects(Feed.self).filter("isFavorite == true")
        return feeds
    }
    
    static func updateFavoriteFeed(_ feed: FeedViewModelType) {
        try! realm.write {
            if let feed = realm.objects(Feed.self).filter("id == %@", feed.id).first {
                feed.isFavorite = !feed.isFavorite
            }
        }
    }
}

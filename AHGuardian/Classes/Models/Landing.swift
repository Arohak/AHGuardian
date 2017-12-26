//
//  Landing.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Landing : Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var total: Int = 0
    @objc dynamic var status: String!
    
    var feeds = List<Feed>()
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(data: JSON) {
        self.init()
        
        self.id     = data["id"].intValue
        self.total  = data["response"]["total"].intValue
        self.status = data["response"]["status"].stringValue
        
        for item in data["response"]["results"].arrayValue {
            let feed = Feed(data: item)
            self.feeds.append(feed)
        }
    }
    
    convenience init(id: Int, total: Int, status: String, feeds: [Feed]) {
        self.init()
        
        self.id     = id
        self.total  = total
        self.status = status
        
        for feed in feeds {
            self.feeds.append(feed)
        }
    }
}


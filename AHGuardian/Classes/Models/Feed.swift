//
//  Feed.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Feed : Object {
    
    @objc dynamic var id: String!
    @objc dynamic var webTitle: String!
    @objc dynamic var sectionName: String!
    @objc dynamic var pillarName: String!
    @objc dynamic var thumbnail: String!
    @objc dynamic var isFavorite: Bool = false
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(data: JSON) {
        self.init()
        
        self.id             = data["id"].stringValue
        self.webTitle       = data["webTitle"].stringValue
        self.sectionName    = data["sectionName"].stringValue
        self.pillarName     = data["pillarName"].stringValue
        self.thumbnail      = data["fields"]["thumbnail"].stringValue
    }
}


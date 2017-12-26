//
//  ConfigHelper.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation
import UIKit

struct ConfigHelper {
    
    static let filename = "Config"
    static let api      = "api"

    static func loadPlist() -> Dictionary<String, AnyObject>? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            return NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject>
        }
        
        return nil
    }
    
    static func getChild(_ name: String) -> Dictionary<String, String>? {
        if let dictionary = loadPlist(), let value = dictionary[name] as? Dictionary<String, String> {
            return value
        }
        
        return nil
    }
    
    //MARK: - API -
    static func getApiBaseUrl() -> String {
        if let dictionary = getChild(api), let value = dictionary["url"] {
            return value
        }
        
        return ""
    }
    
    static func getApiKey() -> String {
        if let dictionary = getChild(api), let value = dictionary["key"] {
            return value
        }
        
        return ""
    }
    
    //MARK: - Realm -
    static func getAppVersionNumber() -> UInt64 {
        if let releaseVersion = Bundle.main.releaseVersion, let buildVersion = Bundle.main.buildVersion {
            let all = releaseVersion + "." + buildVersion
            let array = all.components(separatedBy: ".")
            let value = array.joined(separator: "")
            if let number = UInt64(value) {
                return number
            }
        }
        
        return 0
    }
}

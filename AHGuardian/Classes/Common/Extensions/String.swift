//
//  String.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        var path = Bundle.main.path(forResource: "", ofType: "lproj")
        path = path != nil ? path : ""
        let languageBundle: Bundle!
        if (FileManager.default.fileExists(atPath: path!)) {
            languageBundle = Bundle(path: path!)
            return languageBundle!.localizedString(forKey: self, value: "", table: nil)
        } else{
            languageBundle = Bundle.main
            return languageBundle!.localizedString(forKey: self, value: "", table: nil)
        }
    }
}

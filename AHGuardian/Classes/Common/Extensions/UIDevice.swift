//
//  UIDevice.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation
import UIKit

enum Device {
    static let model                    = UIDevice.current.model
    static let systemVersion            = UIDevice.current.systemVersion
    static let identifier               = UIDevice.current.identifierForVendor
    static let iphone                   = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length < 568.0
    static let iphone_5                 = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length == 568.0
    static let iphone_6                 = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length == 667.0
    static let iphone_6p                = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length == 736.0
    static let ipad                     = UIDevice.current.userInterfaceIdiom == .pad
}

enum Screen {
    static let width                    = UIScreen.main.bounds.size.width
    static let height                   = UIScreen.main.bounds.size.height
    static let max_length               = max(Screen.width, Screen.height)
    static let min_length               = min(Screen.width, Screen.height)
}

enum Scale {
    static let iphone_5 : CGFloat       = 568 / 736
    static let iphone_6 : CGFloat       = 667 / 736
    static let iphone_6p : CGFloat      = 736 / 736
    static let ipad : CGFloat           = 1024 / 736
}

public extension UIDevice {
    
    enum type {
        case Simulator, iPhone_4, iPhone_5, iPhone_6, iPhone_6p, iPhone_7, iPhone_7p, iPad, NON
    }
    
    class var modelType: type {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
            
        } else {
            switch Screen.max_length {
            case 568.0:
                return .iPhone_5
            case 667.0:
                return .iPhone_6
            case 736.0:
                return .iPhone_6p
            default:
                return .NON
            }
        }
    }
}

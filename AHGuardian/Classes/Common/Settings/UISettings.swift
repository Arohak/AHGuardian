//
//  UISettings.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

func scale(size: CGFloat) -> CGFloat {
    switch UIDevice.modelType {
    case .iPhone_4, .iPhone_5:
        return size * Scale.iphone_5
    case .iPhone_6, .iPhone_7:
        return size * Scale.iphone_6
    case .iPhone_6p, .iPhone_7p:
        return size * Scale.iphone_6p
    case .iPad:
        return size * Scale.ipad
    default:
        return 0
    }
}

let nav_title_font : UIFont         = UIFont.systemFont(ofSize: 20)
let bg_color: UIColor               = UIColor(red:50/255, green:50/255, blue:50/255, alpha:1.0)
let collection_height : CGFloat     = scale(size: 150)
let table_img_height : CGFloat      = scale(size: 70)
let max_inset : CGFloat             = scale(size: 16)
let min_inset : CGFloat             = scale(size: 8)

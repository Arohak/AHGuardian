//
//  UIHelper.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import PKHUD

struct UIHelper {

    static func configurateApplicationApperance() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navAppearance = UINavigationBar.appearance()
        navAppearance.isTranslucent = false
        navAppearance.barTintColor = bg_color
        navAppearance.tintColor = .white
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font : nav_title_font]
    }
    
    static func showProgressHUD() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        PKHUD.sharedHUD.show()
    }

    static func hideProgressHUD() {
        PKHUD.sharedHUD.hide()
    }
    
    static func showHUD(_ message: String) {
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: message)
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.5)
    }
}

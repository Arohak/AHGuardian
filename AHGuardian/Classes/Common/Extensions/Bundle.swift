//
//  Bundle.swift
//
/*******************************************************************************
 * IMUSIC LLC. CONFIDENTIAL AND PROPRIETARY
 * FOR USE BY AUTHORIZED PERSONS ONLY
 *
 * This is an unpublished work fully protected by the
 * Armenian copyright laws and is a trade secret
 * belonging to the copyright holder.
 *
 * Copyright (c) 2017 imusic LLC.
 * All Rights Reserved.
 *******************************************************************************/

import Foundation

extension Bundle {
    
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }    
}

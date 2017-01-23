//
//  GenSocial.swift
//  RAB
//
//  Created by RAB on 4/25/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

// USAGE:         GenSocialNetwork.Facebook.openPage()


struct SocialNetworkUrl {
    let scheme: String
    let page: String
    
    func openPage() {
        let schemeUrl = URL(string: scheme)!
        if UIApplication.shared.canOpenURL(schemeUrl) {
            UIApplication.shared.openURL(schemeUrl)
        } else {
            UIApplication.shared.openURL(URL(string: page)!)
        }
    }
}

public enum GenSocialNetwork {
    case facebook, googlePlus, twitter, instagram
    func url() -> SocialNetworkUrl {
        switch self {
        case .facebook: return SocialNetworkUrl(scheme: "fb://profile/163214418213", page: "https://www.facebook.com/PageName")
        case .twitter: return SocialNetworkUrl(scheme: "twitter:///user?screen_name=USERNAME", page: "https://twitter.com/USERNAME")
        case .googlePlus: return SocialNetworkUrl(scheme: "gplus://plus.google.com/u/0/PageId", page: "https://plus.google.com/PageId")
        case .instagram: return SocialNetworkUrl(scheme: "instagram://user?username=USERNAME", page:"https://www.instagram.com/USERNAME")
        }
    }
    public func openPage() {
        self.url().openPage()
    }
}

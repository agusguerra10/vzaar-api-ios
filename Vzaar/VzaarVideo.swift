//
//  VzaarVideo.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarVideo: NSObject{

    public var id: NSNumber?/*objective-C*/
    public var title: String?
    public var user_id: NSNumber?/*objective-C*/
    public var account_id: NSNumber?/*objective-C*/
    public var videoDescription: String?
    public var duration: NSNumber?/*objective-C*/
    public var created_at: String?
    public var updated_at: String?
    public var privateVideo: Bool?
    public var seo_url: String?
    public var url: String?
    public var state: String?
    public var thumbnail_url: String?
    public var embed_code: String?
    public var categories: [VzaarCategory]?
    public var renditions: [VzaarRendition]?
    public var legacy_renditions: [VzaarLegacyRendition]?
    public var account_name: String? //NEW
    public var user_login: String? //NEW
    public var poster_url: String? //NEW
    public var asset_url: String? //NEW
    
    
    public init(withDict dict: NSDictionary){
    
        if let id = dict["id"] as? NSNumber/*objective-C*/{
            self.id = id
        }
        if let title = dict["title"] as? String{
            self.title = title
        }
        if let user_id = dict["user_id"] as? NSNumber/*objective-C*/{
            self.user_id = user_id
        }
        if let account_id = dict["account_id"] as? NSNumber/*objective-C*/{
            self.account_id = account_id
        }
        if let videoDescription = dict["description"] as? String{
            self.videoDescription = videoDescription
        }
        if let duration = dict["duration"] as? NSNumber/*objective-C*/{
            self.duration = duration
        }
        if let created_at = dict["created_at"] as? String{
            self.created_at = created_at
        }
        if let updated_at = dict["updated_at"] as? String{
            self.updated_at = updated_at
        }
        if let privateVideo = dict["private"] as? Bool{
            self.privateVideo = privateVideo
        }
        if let seo_url = dict["seo_url"] as? String{
            self.seo_url = seo_url
        }
        if let url = dict["url"] as? String{
            self.url = url
        }
        if let state = dict["state"] as? String{
            self.state = state
        }
        if let thumbnail_url = dict["thumbnail_url"] as? String{
            self.thumbnail_url = thumbnail_url
        }
        if let embed_code = dict["embed_code"] as? String{
            self.embed_code = embed_code
        }
        if let categories = dict["categories"] as? [NSDictionary]{
            self.categories = [VzaarCategory]()
            for categoryDict in categories{
                let category = VzaarCategory(withDictionary: categoryDict)
                self.categories?.append(category)
            }
        }
        if let renditions = dict["renditions"] as? [NSDictionary]{
            self.renditions = [VzaarRendition]()
            for renditionDict in renditions{
                let rendition = VzaarRendition(withDict: renditionDict)
                self.renditions?.append(rendition)
            }
        }
        if let legacy_renditions = dict["legacy_renditions"] as? [NSDictionary]{
            self.legacy_renditions = [VzaarLegacyRendition]()
            for legacy_renditionDict in legacy_renditions{
                let legacy_rendition = VzaarLegacyRendition(withDict: legacy_renditionDict)
                self.legacy_renditions?.append(legacy_rendition)
            }
        }
        if let account_name = dict["account_name"] as? String{
            self.account_name = account_name
        }
        if let user_login = dict["user_login"] as? String{
            self.user_login = user_login
        }
        if let poster_url = dict["poster_url"] as? String{
            self.poster_url = poster_url
        }
        if let asset_url = dict["asset_url"] as? String{
            self.asset_url = asset_url
        }
        
    }
}

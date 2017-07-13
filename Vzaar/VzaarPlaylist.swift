//
//  VzaarPlaylist.swift
//  Vzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarPlaylist: NSObject{
    
    public var id: Int?
    public var title: String?
    public var sort_order: String?
    public var sort_by: String?
    public var max_vids: Int?
    public var position: String?
    public var privacy: Bool?
    public var dimensions: String?
    public var autoplay: Bool?
    public var continuous_play: Bool?
    public var category_id: Int?
    public var embed_code: String?
    public var created_at: String?
    public var updated_at: String?
    
    
    public init(withDict dict: NSDictionary){
        if let id = dict["id"] as? Int{
            self.id = id
        }
        if let title = dict["title"] as? String{
            self.title = title
        }
        if let sort_order = dict["sort_order"] as? String{
            self.sort_order = sort_order
        }
        if let sort_by = dict["sort_by"] as? String{
            self.sort_by = sort_by
        }
        if let max_vids = dict["max_vids"] as? Int{
            self.max_vids = max_vids
        }
        if let position = dict["position"] as? String{
            self.position = position
        }
        if let privacy = dict["private"] as? Bool{
            self.privacy = privacy
        }
        if let dimensions = dict["dimensions"] as? String{
            self.dimensions = dimensions
        }
        if let autoplay = dict["autoplay"] as? Bool{
            self.autoplay = autoplay
        }
        if let continuous_play = dict["continuous_play"] as? Bool{
            self.continuous_play = continuous_play
        }
        if let category_id = dict["category_id"] as? Int {
            self.category_id = category_id
        }
        if let embed_code = dict["embed_code"] as? String{
            self.embed_code = embed_code
        }
        if let created_at = dict["created_at"] as? String{
            self.created_at = created_at
        }
        if let updated_at = dict["updated_at"] as? String{
            self.updated_at = updated_at
        }
        
    }
    
    
}

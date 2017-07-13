//
//  VzaarUpdatePlaylistParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 30/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit

public class VzaarUpdatePlaylistParameters: VzaarRequestParameters {
    
    //Playlist id - REQUIRED
    public var id: NSNumber?/*objective-C*/
    //Playlist title
    public var title: String?
    //Sort field for the playlist videos. Must be one of title or created_at
    public var sort_by: String?
    //Sort order for the playlist videos
    public var sort_order: String?
    //If the playlist is private, it cannot be viewed by others on the vzaar website
    public var privacy: NSNumber?/*objective-C*/
    //Width and height for the playlist, must be in the format 780x340
    public var dimensions: String?
    //The maximum number of videos in the playlist.
    public var max_vids: NSNumber?/*objective-C*/
    //Which side the playlist controls show. Must be one of top, right, bottom, left
    public var position: String?
    //Should the first video in the playlist autoplay
    public var autoplay: NSNumber?/*objective-C*/
    //Should all the videos autoplay after each finishes
    public var continuous_play: NSNumber?/*objective-C*/
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber/*objective-C*/){
        self.init()
        
        self.id = id
        super.method = MethodType.patch
        super.urlSuffix = "feeds/playlists/\(id)"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let title = title{ params["title"] = title }
        if let sort_by = sort_by{ params["sort_by"] = sort_by }
        if let sort_order = sort_order{ params["sort_order"] = sort_order }
        if let privacy = privacy{ params["private"] = privacy }
        if let dimensions = dimensions{ params["dimensions"] = dimensions }
        if let max_vids = max_vids{ params["max_vids"] = max_vids }
        if let position = position{ params["position"] = position }
        if let autoplay = autoplay{ params["autoplay"] = autoplay }
        if let continuous_play = continuous_play{ params["continuous_play"] = continuous_play }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

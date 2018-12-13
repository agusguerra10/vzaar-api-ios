//
//  VzaarDeletePlaylistParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 30/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit

public class VzaarDeletePlaylistParameters: VzaarRequestParameters {

    //Playlist id - REQUIRED
    public var id: NSNumber?/* Objective-c compatible */
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber) {
        self.init()
        
        self.id = id
        super.method = MethodType.delete
        super.urlSuffix = "feeds/playlists/\(id)"
    }
    
}

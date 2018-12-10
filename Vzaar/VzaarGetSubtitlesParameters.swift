//
//  VzaarGetSubtitlesParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 04/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import UIKit

public class VzaarGetSubtitlesParameters: VzaarRequestParameters {
    
    //Video id - REQUIRED
    public var id: Int32?
    
    override init() {
        super.init()
    }
    
    public convenience init(id: Int32) {
        self.init()
        
        self.id = id
        super.method = MethodType.get
        super.urlSuffix = "videos/\(id)/subtitles"
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        return super.createRequest(withConfig: config)
    }
    
}

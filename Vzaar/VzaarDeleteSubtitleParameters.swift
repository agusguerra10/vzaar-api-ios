//
//  VzaarDeleteSubtitleParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 04/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import UIKit

public class VzaarDeleteSubtitlesParameters: VzaarRequestParameters {
    
    //Video id - REQUIRED
    public var id: NSNumber?/* Objective-c compatible */
    //Subtitle id - REQUIRED
    public var subtitle: NSNumber?/* Objective-c compatible */
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber, subtitle: NSNumber) {
        self.init()
        
        self.id = id
        self.subtitle = subtitle
        super.method = MethodType.delete
        super.urlSuffix = "videos/\(id)/subtitles/\(subtitle)"
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        return super.createRequest(withConfig: config)
    }
    
}

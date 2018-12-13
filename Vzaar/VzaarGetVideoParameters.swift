//
//  VzaarGetVideoParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarGetVideoParameters: VzaarRequestParameters {
    
    //Video id - REQUIRED
    public var id: NSNumber?/* Objective-c compatible */
    
    override init(){
        super.init()
    }
    
    public convenience init(id: NSNumber){
        self.init()
        
        self.id = id
        super.method = MethodType.get
        super.urlSuffix = "videos/\(id)"
    }
    
    
}

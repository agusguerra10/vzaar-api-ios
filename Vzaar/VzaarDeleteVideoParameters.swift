//
//  VzaarDeleteVideoParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarDeleteVideoParameters: VzaarRequestParameters{
    
    //Video id - REQUIRED
    public var id: Int32?
    
    override init() {
        super.init()
    }
    
    public convenience init(id: Int32) {
        self.init()
        
        self.id = id
        super.method = MethodType.delete
        super.urlSuffix = "videos/\(id)"
    }
    
}

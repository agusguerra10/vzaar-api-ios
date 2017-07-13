//
//  VzaarDeleteIngestRecipeParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarDeleteIngestRecipeParameters: VzaarRequestParameters{
    
    //Ingest Recipe id - REQUIRED
    public var id: NSNumber?/*objective-C*/
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber/*objective-C*/) {
        self.init()
        
        self.id = id
        super.method = MethodType.delete
        super.urlSuffix = "ingest_recipes/\(id)"
    }
    
}

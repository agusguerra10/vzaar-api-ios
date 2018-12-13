//
//  VzaarGetIngestRecipeParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarGetIngestRecipeParameters: VzaarRequestParameters {
    
    //Ingest Recipe id - REQUIRED
    public var id: NSNumber?/* Objective-c compatible */
    
    override init(){
        super.init()
    }
    
    public convenience init(id: NSNumber){
        self.init()
        
        self.id = id
        super.method = MethodType.get
        super.urlSuffix = "ingest_recipes/\(id)"
    }
    
    
}

//
//  Meta.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class Meta: NSObject{
    
    public var total_count: Int?
    public var links: Links?


    public init(withDictionary dict: NSDictionary){
        
        if let total_count = dict["total_count"] as? Int{
            self.total_count = total_count
        }
        if let links = dict["links"] as? NSDictionary{
            self.links = Links(withDict: links)
        }
        
    }
    
}


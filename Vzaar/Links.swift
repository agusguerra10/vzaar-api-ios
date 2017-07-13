//
//  Links.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class Links: NSObject{
    
    public var first: String?
    public var next: String?
    public var previous: String?
    public var last: String?

    public init(withDict dict: NSDictionary){
        
        if let first = dict["first"] as? String{
            self.first = first
        }
        if let next = dict["next"] as? String{
            self.next = next
        }
        if let previous = dict["previous"] as? String{
            self.previous = previous
        }
        if let last = dict["last"] as? String{
            self.last = last
        }
        
    }
    
}

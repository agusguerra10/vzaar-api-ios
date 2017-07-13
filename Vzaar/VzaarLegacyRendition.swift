//
//  VzaarLegacyRendition.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarLegacyRendition: NSObject{
    
    public var id: NSNumber?/*objective-C*/
    public var type: String?
    public var width: NSNumber?/*objective-C*/
    public var height: NSNumber?/*objective-C*/
    public var bitrate: NSNumber?/*objective-C*/
    public var status: String?
    
    public init(withDict dict: NSDictionary){
        
        if let id = dict["id"] as? NSNumber/*objective-C*/{
            self.id = id
        }
        if let type = dict["type"] as? String{
            self.type = type
        }
        if let width = dict["width"] as? NSNumber/*objective-C*/{
            self.width = width
        }
        if let height = dict["height"] as? NSNumber/*objective-C*/{
            self.height = height
        }
        if let bitrate = dict["bitrate"] as? NSNumber/*objective-C*/{
            self.bitrate = bitrate
        }
        if let status = dict["status"] as? String{
            self.status = status
        }
        
    }
    
}

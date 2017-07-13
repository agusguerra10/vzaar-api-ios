//
//  VzaarLegacyRendition.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarLegacyRendition: NSObject{
    
    public var id: Int?
    public var type: String?
    public var width: Int?
    public var height: Int?
    public var bitrate: Int?
    public var status: String?
    
    public init(withDict dict: NSDictionary){
        
        if let id = dict["id"] as? Int{
            self.id = id
        }
        if let type = dict["type"] as? String{
            self.type = type
        }
        if let width = dict["width"] as? Int{
            self.width = width
        }
        if let height = dict["height"] as? Int{
            self.height = height
        }
        if let bitrate = dict["bitrate"] as? Int{
            self.bitrate = bitrate
        }
        if let status = dict["status"] as? String{
            self.status = status
        }
        
    }
    
}

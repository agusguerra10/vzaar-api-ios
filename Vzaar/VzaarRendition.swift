//
//  VzaarRentition.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarRendition: NSObject{
    
    public var id: Int?
    public var width: Int?
    public var height: Int?
    public var bitrate: Int?
    public var framerate: String?
    public var status: String?
    public var size_in_bytes: Int?
    
    public init(withDict dict: NSDictionary){
        
        if let id = dict["id"] as? Int{
            self.id = id
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
        if let framerate = dict["framerate"] as? String{
            self.framerate = framerate
        }
        if let status = dict["status"] as? String{
            self.status = status
        }
        if let size_in_bytes = dict["size_in_bytes"] as? Int{
            self.size_in_bytes = size_in_bytes
        }
        
    }
    
}

//
//  VzaarRentition.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarRendition: NSObject{
    
    public var id: NSNumber?/*objective-C*/
    public var width: NSNumber?/*objective-C*/
    public var height: NSNumber?/*objective-C*/
    public var bitrate: NSNumber?/*objective-C*/
    public var framerate: String?
    public var status: String?
    public var size_in_bytes: NSNumber?/*objective-C*/
    
    public init(withDict dict: NSDictionary){
        
        if let id = dict["id"] as? NSNumber/*objective-C*/{
            self.id = id
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
        if let framerate = dict["framerate"] as? String{
            self.framerate = framerate
        }
        if let status = dict["status"] as? String{
            self.status = status
        }
        if let size_in_bytes = dict["size_in_bytes"] as? NSNumber/*objective-C*/{
            self.size_in_bytes = size_in_bytes
        }
        
    }
    
}

//
//  VzaarSignature.swift
//  Vzaar
//
//  Created by Andreas Bagias on 02/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarSignature: NSObject{
    
    public var access_key_id: String?
    public var key: String?
    public var acl: String?
    public var policy: String?
    public var signature: String?
    public var success_action_status: String?
    public var content_type: String?
    public var guid: String?
    public var bucket: String?
    public var upload_hostname: String?
    public var part_size: Int?
    public var part_size_in_bytes: Int?
    public var parts: Int?
    
    
    init(withDictionary dict: NSDictionary){
        
        if let access_key_id = dict["access_key_id"] as? String{
            self.access_key_id = access_key_id
        }
        if let key = dict["key"] as? String{
            self.key = key
        }
        if let acl = dict["acl"] as? String{
            self.acl = acl
        }
        if let policy = dict["policy"] as? String{
            self.policy = policy
        }
        if let signature = dict["signature"] as? String{
            self.signature = signature
        }
        if let success_action_status = dict["success_action_status"] as? String{
            self.success_action_status = success_action_status
        }
        if let content_type = dict["content_type"] as? String{
            self.content_type = content_type
        }
        if let guid = dict["guid"] as? String{
            self.guid = guid
        }
        if let bucket = dict["bucket"] as? String{
            self.bucket = bucket
        }
        if let upload_hostname = dict["upload_hostname"] as? String{
            self.upload_hostname = upload_hostname
        }
        if let part_size = dict["part_size"] as? Int{
            self.part_size = part_size
        }
        if let part_size_in_bytes = dict["part_size_in_bytes"] as? Int{
            self.part_size_in_bytes = part_size_in_bytes
        }
        if let parts = dict["parts"] as? Int{
            self.parts = parts
        }
        
    
    }
    
        
    
    
}




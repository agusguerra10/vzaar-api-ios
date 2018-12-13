//
//  VzaarSubtitle.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import UIKit

public class VzaarSubtitle: NSObject {

    public var id: Int?
    public var code: String?
    public var title: String?
    public var language: String?
    public var created_at: String?
    public var updated_at: String?
    public var url: String?
    
    public init(withDict dict: NSDictionary){
        
        if let id = dict["id"] as? Int{
            self.id = id
        }
        if let code = dict["code"] as? String{
            self.code = code
        }
        if let title = dict["title"] as? String{
            self.title = title
        }
        if let language = dict["language"] as? String{
            self.language = language
        }
        if let created_at = dict["created_at"] as? String{
            self.created_at = created_at
        }
        if let updated_at = dict["updated_at"] as? String{
            self.updated_at = updated_at
        }
        
    }
    
}

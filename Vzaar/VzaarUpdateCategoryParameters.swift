//
//  VzaarUpdateCategoryParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarUpdateCategoryParameters: VzaarRequestParameters{
    
    //Category id - REQUIRED
    public var id: NSNumber?/*objective-C*/
    //Rename the category
    public var name: String?
    //Move the category underneath an existing parent node
    public var parent_id: NSNumber?/*objective-C*/
    //Move the category to the top level. Can not be used in combination with parent_id
    public var move_to_root: NSNumber?/*objective-C*/
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber/*objective-C*/) {
        self.init()
        
        self.id = id
        super.method = MethodType.patch
        super.urlSuffix = "categories/\(id)"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let name = name{
            params["name"] = name
        }
        if let parent_id = parent_id{
            params["parent_id"] = parent_id
        }
        if let move_to_root = move_to_root{
            params["move_to_root"] = move_to_root
        }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

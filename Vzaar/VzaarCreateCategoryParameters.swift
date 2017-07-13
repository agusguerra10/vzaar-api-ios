//
//  VzaarCreateCategoryParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarCreateCategoryParameters: VzaarRequestParameters {
    
    //Name for the category - REQUIRED
    public var name: String?
    //Create as a subcategory
    public var parent_id: NSNumber?/*objective-C*/

    override init() {
        super.init()
    }
    
    public convenience init(name: String){
        self.init()
        
        self.name = name
        super.method = MethodType.post
        super.urlSuffix = "categories"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let name = name{ params["name"] = name }
        if let parent_id = parent_id{ params["parent_id"] = parent_id }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

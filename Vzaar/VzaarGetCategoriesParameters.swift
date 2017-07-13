//
//  VzaarGetCategoriesParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarGetCategoriesParameters: VzaarRequestParameters {
    
    //Video attribute to sort results with.
    public var sort: String?
    //Specify sort order. Acceptable values are: asc, desc
    public var order: String?
    //Page number for paginated results.
    public var page: NSNumber?/*objective-C*/
    //Number of results per paginated page result.
    public var per_page: NSNumber?/*objective-C*/
    //Number of hierarchy levels to include. This is one-based so a value of 2 would return your root categories and only their immediate child categories
    public var levels: NSNumber?/*objective-C*/
    //List of category id values to allow granular control of result list.
    public var ids: [NSNumber/*objective-C*/]?
    
    public override init(){
        super.init()
        
        super.method = MethodType.get
        super.urlSuffix = "categories"
    }
    
    func createQueryParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let sort = sort{ params["sort"] = sort }
        if let order = order{ params["order"] = order }
        if let page = page{ params["page"] = page }
        if let per_page = per_page{ params["per_page"] = per_page }
        if let levels = levels{ params["levels"] = levels }
        if let ids = ids{ params["ids"] = ids }
        
        queryParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createQueryParameters()
        return super.createRequest(withConfig: config)
    }
}

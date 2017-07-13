//
//  VzaarUpdateVideoParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarUpdateVideoParameters: VzaarRequestParameters{
    
    //Video id - REQUIRED
    public var id: NSNumber?/*objective-C*/
    //Video title. If not provided this will default to your source filename.
    public var title: String?
    //Video description.
    public var videoDescription: String?
    //Private videos cannot be publicly viewed on vzaar.com
    public var privacy: NSNumber?/*objective-C*/
    //URL for SEO purposes
    public var seo_url: String?
    //List of category id values to associate with this video.
    public var category_ids: [NSNumber/*objective-C*/]?
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber/*objective-C*/) {
        self.init()
        
        self.id = id
        super.method = MethodType.patch
        super.urlSuffix = "videos/\(id)"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        
        if let title = title{
            params["title"] = title
        }
        if let videoDescription = videoDescription{
            params["description"] = videoDescription
        }
        if let privacy = privacy{
            params["private"] = privacy
        }
        if let seo_url = seo_url{
            params["seo_url"] = seo_url
        }
        if let category_ids = category_ids{
            params["category_ids"] = category_ids
        }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

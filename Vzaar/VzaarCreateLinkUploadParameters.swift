//
//  File.swift
//  Vzaar
//
//  Created by Andreas Bagias on 30/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarCreateLinkUploadParameters: VzaarRequestParameters{
    
    //Url to video file. - REQUIRED
    public var url: String?
    //REQUIRED (HARDCODED) uploader description used for metadata, analytics and support
    private var uploader: String = "ios-sdk-1.0.1"
    //Specify if you do not want to use your default Ingest Recipe.
    public var ingest_recipe_id: NSNumber?/*objective-C*/
    //Video title. If not provided this will default to your source filename.
    public var title: String?
    //Video description.
    public var linkDescription: String?
    
    override init() {
        super.init()
    }
    
    public convenience init(url: String) {
        self.init()
        
        self.url = url
        super.method = MethodType.post
        super.urlSuffix = "link_uploads"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let url = url{ params["url"] = url }
        params["uploader"] = uploader
        if let ingest_recipe_id = ingest_recipe_id{ params["ingest_recipe_id"] = ingest_recipe_id }
        if let title = title{ params["title"] = title }
        if let linkDescription = linkDescription{ params["description"] = linkDescription }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

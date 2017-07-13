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
    //Uploader description used for metadata, analytics and support - REQUIRED
    public var uploader: String?
    //Specify if you do not want to use your default Ingest Recipe.
    public var ingest_recipe_id: Int32?
    //Video title. If not provided this will default to your source filename.
    public var title: String?
    //Video description.
    public var linkDescription: String?
    
    override init() {
        super.init()
    }
    
    public convenience init(url: String, uploader: String) {
        self.init()
        
        super.method = MethodType.post
        super.urlSuffix = "link_uploads"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let url = url{ params["url"] = url }
        if let uploader = uploader{ params["uploader"] = uploader }
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

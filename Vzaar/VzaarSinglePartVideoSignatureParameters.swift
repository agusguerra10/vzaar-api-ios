//
//  SinglePartVideoSignatureParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 02/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarSinglePartVideoSignatureParameters: VzaarRequestParameters {

    override init(){
        super.init()
        
        super.method = MethodType.post
        super.urlSuffix = "signature/single"
    }
    
    //REQUIRED  uploader description used for metadata, analytics and support
    public var uploader: String?
    //OPTIONAL  base name of your video file
    public var filename: String?
    //OPTIONAL  size in bytes of your video file
    public var filesize: Int64?
    
    public convenience init(uploader: String){
        self.init()
        
        self.uploader = uploader


    }
    
    public convenience init(uploader: String, filename: String, filesize: Int64){
        self.init()
        
        self.uploader = uploader
        self.filename = filename
        self.filesize = filesize
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        params["uploader"] = uploader
        if let filename = filename{
            params["filename"] = filename
        }
        if let filesize = filesize{
            params["filesize"] = filesize
        }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

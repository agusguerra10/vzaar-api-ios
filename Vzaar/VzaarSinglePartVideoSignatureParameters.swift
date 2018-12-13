//
//  SinglePartVideoSignatureParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 02/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarSinglePartVideoSignatureParameters: VzaarRequestParameters {

    //REQUIRED (HARDCODED) uploader description used for metadata, analytics and support
    private var uploader: String = "ios-sdk-1.0.1"
    //OPTIONAL  base name of your video file
    public var filename: String?
    //OPTIONAL  size in bytes of your video file
    public var filesize: NSNumber?/*objective-C*/

    public override init(){
        super.init()
        
        super.method = MethodType.post
        super.urlSuffix = "signature/single/2"
    }

    public convenience init(filename: String, filesize: NSNumber/*objective-C*/){
        self.init()
        
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

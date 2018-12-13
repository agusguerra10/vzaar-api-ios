//
//  MultiPartVideoSignatureParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 02/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarMultiPartVideoSignatureParameters: VzaarRequestParameters {
    
    /*
     * If you do not provide a desired part size, vzaar will determine the best part size for you to use based on your file size.
     * If your file size is less than the default part size, you will be provided with the part size to use.
     * If you specify a desired part size, this will be validated.
     * The signature will contain either your desired part size if you provided a valid value, or in the case
     * that your desired part size is invalid, a valid part size will be provided.
     *
     * You MUST specify a desired part size in MB
     */
    
    //REQUIRED (HARDCODED) uploader description used for metadata, analytics and support
    private var uploader: String = "ios-sdk-1.0.1"
    //REQUIRED  base name of your video file
    public var filename: String?
    //REQUIRED  size in bytes of your video file
    public var filesize: NSNumber?/*objective-C*/
    //OPTIONAL  desired part size specified as a string
    public var desired_part_size: String?
    
    public override init(){
        super.init()
        
        super.method = MethodType.post
        super.urlSuffix = "signature/multipart/2"
    }

    public convenience init(filename: String, filesize: NSNumber/*objective-C*/){

        self.init()
        
        self.filename = filename
        self.filesize = filesize

    }

    public convenience init(filename: String, filesize: NSNumber/*objective-C*/, desired_part_size: String){

        self.init()
        
        self.filename = filename
        self.filesize = filesize
        self.desired_part_size = desired_part_size
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        params["uploader"] = uploader
        params["filename"] = filename
        params["filesize"] = filesize
        if let desired_part_size = desired_part_size{
            params["desired_part_size"] = desired_part_size
        }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

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
    
    
    override init(){
        super.init()
        
        super.method = MethodType.post
        super.urlSuffix = "signature/multipart"
    }
   
    //REQUIRED  uploader description used for metadata, analytics and support
    public var uploader: String?
    //REQUIRED  base name of your video file
    public var filename: String?
    //REQUIRED  size in bytes of your video file
    public var filesize: Int64?
    //OPTIONAL  desired part size specified as a string
    public var desired_part_size: String?
    
    public convenience init(uploader: String, filename: String, filesize: Int64){
        self.init()
        
        self.uploader = uploader
        self.filename = filename
        self.filesize = filesize

    }
    
    public convenience init(uploader: String, filename: String, filesize: Int64, desired_part_size: String){
        self.init()
        
        self.uploader = uploader
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

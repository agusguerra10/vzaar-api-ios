//
//  VideoCreationParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarCreateVideoParameters: VzaarRequestParameters{

    /*
     * Before creating a video you must first generate an upload signature and upload your source video. 
     * The upload signature allows you to upload directly to the vzaar upload bucket on AWS S3. 
     * Once your video has been successfully uploaded, you can then proceed with video creation.
     * Unless you are implementing your own custom upload process, this should be handled by the official client library of your choice.
     * For more information about upload signatures, please refer to the Upload Signatures documentation.
     */
    
    public var guid: String?
    public var ingest_recipe_id: NSNumber?/*objective-C*/
    public var title: String?
    public var paramDescription: String?
    
    override init(){
        super.init()
        
        super.method = MethodType.post
        super.urlSuffix = "videos"
    }
    
    public convenience init(guid: String){
        self.init()
        
        self.guid = guid
    }
    
    /**
     *  Initializers for the video creation parameters
     *
     *  @param guid                    REQUIRED  Provided in signature
     *  @param ingest_recipe_id        OPTIONAL  Specify if you do not want to use your default Ingest Recipe
     *  @param title                   OPTIONAL  Video title. If not provided this will default to your source filename
     *  @param paramDescription             OPTIONAL  Video description
     */
    public convenience init(guid: String, ingest_recipe_id: NSNumber/*objective-C*/, title: String, paramDescription: String){
        self.init()
        
        self.guid = guid
        self.ingest_recipe_id = ingest_recipe_id
        self.title = title
        self.paramDescription = paramDescription
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        params["guid"] = guid
        if let ingest_recipe_id = ingest_recipe_id{
            params["ingest_recipe_id"] = ingest_recipe_id
        }
        if let title = title{
            params["title"] = title
        }
        if let paramDescription = paramDescription{
            params["description"] = paramDescription
        }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

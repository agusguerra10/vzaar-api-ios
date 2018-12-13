//
//  VzaarUploadImageFrameParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarUploadImageFrameParameters: VzaarRequestParameters {
    
    //Video id - REQUIRED
    public var id: NSNumber?/* Objective-c compatible */
    //Seconds into video to generate poster frame from
    public var image: UIImage?
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber, image: UIImage) {
        self.init()
        
        self.id = id
        self.image = image
        super.method = MethodType.post
        super.urlSuffix = "videos/\(id)/image"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let image = image{
            if let imageData = UIImageJPEGRepresentation(image, 1){
                params["image"] = imageData
            }
        }
        
        
        bodyParameters = params
    }

    override func createImageRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createImageRequest(withConfig: config)
    }
}

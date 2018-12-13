//
//  VzaarUpdateSubtitleParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 04/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import UIKit

public class VzaarUpdateSubtitleParameters: VzaarRequestParameters {

    //Video id - REQUIRED
    public var id: NSNumber?/* Objective-c compatible */
    //Subtitle id - REQUIRED
    public var subtitle: NSNumber?/* Objective-c compatible */
    //Language code
    public var code: String?
    //Name for subtitle file
    public var title: String?
    //Subtitle content
    public var content: String?
    //Subtitle file path
    public var file: String?
    
    override init() {
        super.init()
    }
    
    public convenience init(id: NSNumber, subtitle: NSNumber) {
        self.init()
        
        self.id = id
        self.subtitle = subtitle
        super.method = MethodType.patch
        super.urlSuffix = "videos/\(id)/subtitles/\(subtitle)"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let code = code{ params["code"] = code }
        if let title = title{ params["title"] = title }
        if let content = content{ params["content"] = content }
        if let file = file{
            
            params["file"] = file
            
        }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        
        if file == nil{
            return super.createRequest(withConfig: config)
        }else{
            return super.createFileRequest(withConfig: config)
        }
        
    }
    
}

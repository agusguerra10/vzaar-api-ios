//
//  VzaarUpdateImageFrameParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 03/12/2018.
//  Copyright © 2018 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarUpdateImageFrameParameters: VzaarRequestParameters {

    //Video id - REQUIRED
    public var id: Int32?
    //Seconds into video to generate poster frame from
    public var time: Float?
    
    override init() {
        super.init()
    }
    
    public convenience init(id: Int32) {
        self.init()
        
        self.id = id
        super.method = MethodType.patch
        super.urlSuffix = "videos/\(id)/image"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let time = time{ params["time"] = time }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
}

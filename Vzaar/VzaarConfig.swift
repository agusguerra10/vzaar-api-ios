//
//  VzaarConfig.swift
//  Vzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarConfig: NSObject{
    
    public var clientId: String
    public var authToken: String
    
    public init(clientId: String, authToken: String){
        self.clientId = clientId
        self.authToken = authToken
    }
    
}

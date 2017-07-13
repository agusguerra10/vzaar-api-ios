//
//  SignatureParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 28/02/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarSignatureParameters: VzaarRequestParameters{

    public var uploader: String?
    public var filename: String?
    public var filesize: Int64?
    
    override init(){
        super.init()
    }
    
}

//
//  VideoBuilder.swift
//  Vzaar
//
//  Created by Andreas Bagias on 28/02/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarRequestParameters: NSObject{
   
    var baseURL = "https://api.vzaar.com/api/v2/"
    var urlSuffix = ""
    var method: MethodType?
    var queryParameters: Dictionary<String, Any>?
    var bodyParameters: Dictionary<String, Any>?
    
    public override init(){
        
    }
    
    func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest{
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        
        request.httpMethod = (method?.rawValue)!
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(config.clientId, forHTTPHeaderField: "X-Client-Id")
        request.addValue(config.authToken, forHTTPHeaderField: "X-Auth-Token")
        request.url = getURL()
        request.httpBody = getBody()
        
        print("\(request.httpMethod)         \(getURL())")
        
        return request
    }
    
    func getURL() -> URL{
        
        var urlString = "\(baseURL)\(urlSuffix)"
        
        if let queryParameters = queryParameters{
            urlString += "?"
            for param in queryParameters{
                urlString = urlString + "\(param.key)=\(param.value)&"
            }
            urlString = urlString.substring(to: urlString.index(before: urlString.endIndex))
        }
        
        return URL(string:  urlString)!

    }
    
    func getBody() -> Data?{
        
        guard let bodyParameters = bodyParameters else { return nil }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: bodyParameters)
            return data
            
        } catch _ {
            return nil
        }
    }
    
}

enum MethodType: String{
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
    case post = "POST"
}





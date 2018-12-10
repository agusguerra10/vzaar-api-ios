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
    
    func createFileRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest{
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        
        request.httpMethod = (method?.rawValue)!
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(config.clientId, forHTTPHeaderField: "X-Client-Id")
        request.addValue(config.authToken, forHTTPHeaderField: "X-Auth-Token")
        request.url = getURL()
        
        if let bodyparameters = bodyParameters, let file = bodyparameters["file"] as? String{
            
            let url = URL(fileURLWithPath: file)
            let fileData = try! Data(contentsOf: url)
            
            let filename = url.lastPathComponent
            
            var dictionary: [String: String] = [String: String]()
            
            if let code = bodyparameters["code"] as? String{
                dictionary["code"] = code
            }
            if let title = bodyparameters["title"] as? String{
                dictionary["title"] = title
            }
            
            request.httpBody = createBody(parameters: dictionary, boundary: boundary, data: fileData, name: "file", mimeType: "text/plain", filename: filename)
        }
        
        return request
    }
    
    func createImageRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest{
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
        
        request.httpMethod = (method?.rawValue)!
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(config.clientId, forHTTPHeaderField: "X-Client-Id")
        request.addValue(config.authToken, forHTTPHeaderField: "X-Auth-Token")
        request.url = getURL()
        
        if let bodyparameters = bodyParameters, let imageData = bodyparameters["image"] as? Data{
            request.httpBody = createBody(parameters: [:], boundary: boundary, data: imageData, name: "image", mimeType: "application/octet-stream", filename: "image.jpg")
        }
        
        return request
    }
    
    private func createBody(parameters: [String: String],
                            boundary: String,
                            data: Data,
                            name: String,
                            mimeType: String,
                            filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n")
            let valueData = value.data(using: String.Encoding.utf8, allowLossyConversion: false)
            if let valueData = valueData{
                body.appendString("Content-Length: \(valueData.count)\r\n\r\n")

            }
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Length: \(data.count)\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    
}

enum MethodType: String{
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
    case post = "POST"
}





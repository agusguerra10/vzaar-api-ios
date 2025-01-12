//
//  Aws.swift
//  Vzaar
//
//  Created by Andreas Bagias on 28/02/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

protocol AWSUploadProgressDelegate {
    func awsUploadProgress(progress: Double)
}

class AWS: NSObject, URLSessionDelegate, URLSessionDataDelegate{
    
    static var instance: AWS!
    var totalBytes:Int64!
    var bytes:Int64 = 0
    var totalBytesSent:Int64 = 0
    
    var delegate: AWSUploadProgressDelegate!
    var uploadTask: URLSessionTask!
    
    class func sharedInstance()-> AWS {
        self.instance = (self.instance ?? AWS())
        return self.instance
    }
    
    override init(){
        super.init()
    }
    
    func cancelUploadTask(){
        if uploadTask != nil {
            uploadTask.cancel()
        }
    }
    
    func suspendUploadTask(){
        if uploadTask != nil {
            uploadTask.suspend()
        }
    }
    
    func resumeUploadTask(){
        if uploadTask != nil {
            uploadTask.resume()
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        print("bytesSent:\(bytesSent) totalBytesSent:\(totalBytesSent) totalBytesExpectedToSend:\(totalBytesExpectedToSend)")
        
        var total: Int64 = totalBytesExpectedToSend
        if self.totalBytes != nil {
            total = self.totalBytes
        }
        
        self.bytes += bytesSent
        self.totalBytesSent = totalBytesSent
        
        let x = Float(self.bytes)/Float(total)
        let percentage = Double(round(100*x)/100)
        if delegate != nil { delegate.awsUploadProgress(progress: percentage) }
    }

    func postFile(fileURLPath: URL,
                         signature: VzaarSignature,
                         singlePartVideoSignatureParameters: VzaarSinglePartVideoSignatureParameters,
                         success: @escaping (_ data: Data?, _ response: URLResponse?) -> Void,
                         failure: @escaping (_ error:Error?) -> Void){
    
        var filename: String!
        if let fn = singlePartVideoSignatureParameters.filename{
            filename = fn
        }
        
        resetBytesCounters()
        
        postPart(fileURLPath: fileURLPath, signature: signature, part: nil, filename: filename, success: { (data, response) in
            success(data, response)
        }) { (error) in
            failure(error)
        }
        
    }
    
    func postFile(fileURLPath: URL,
                  signature: VzaarSignature,
                  multiPartVideoSignatureParameters: VzaarMultiPartVideoSignatureParameters,
                  success: @escaping () -> Void,
                  failure: @escaping (_ error:Error?) -> Void){
        
        resetBytesCounters()
        self.totalBytes = multiPartVideoSignatureParameters.filesize!
        
        postParts(fileURLPath: fileURLPath, signature: signature, multiPartVideoSignatureParameters: multiPartVideoSignatureParameters, success: { 
            
            success()
            
        }) { (error) in
            failure(error)
        }
        
    }
    
    private func resetBytesCounters(){
        self.bytes = 0
        self.totalBytes = nil
        self.totalBytesSent = 0
    }
    
    private func postPart(fileURLPath: URL,
                  signature: VzaarSignature,
                  part: Int?,
                  filename: String?,
                  success: @escaping (_ data: Data?, _ response: URLResponse?) -> Void,
                  failure: @escaping (_ error:Error?) -> Void){
    
        if let key = signature.key ,
            let policy = signature.policy,
            let x_amz_signature = signature.x_amz_signature,
            let x_amz_date = signature.x_amz_date,
            let x_amz_algorithm = signature.x_amz_algorithm,
            let x_amz_credential = signature.x_amz_credential,
            let success_action_status = signature.success_action_status,
            let acl = signature.acl,
            let upload_hostname = signature.upload_hostname,
            let bucket = signature.bucket{
            
            let lastPathComponent = fileURLPath.lastPathComponent
            let pathExtension = (lastPathComponent as NSString).pathExtension
            
            var name = "video_\(Int(Date().timeIntervalSince1970))"
            let type = pathExtension
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: upload_hostname)!)
            request.httpMethod = "POST"
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/mixed; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(acl, forHTTPHeaderField: "x-amazon-acl")
            request.setValue("multipart/form-data", forHTTPHeaderField: "Enclosure-Type")
            
            var keySuffix = ""
            if let part = part {
                keySuffix = ".\(part)"
            }
            if let n = filename{
                if n != ""{ name = n }
            }
            
            let videoDictionary = ["key":key.replacingOccurrences(of: "${filename}", with: "\(name)\(keySuffix)"),
                                   "acl": acl,
                                   "policy": policy,
                                   "success_action_status": success_action_status,
                                   "X-Amz-Algorithm":x_amz_algorithm,
                                   "X-Amz-Credential":x_amz_credential,
                                   "X-Amz-Date":x_amz_date,
                                   "X-Amz-Signature":x_amz_signature,
                                   "bucket": bucket,
                                   "x-amz-meta-uploader": "iOS-Swift"]
        
            do{
                
                var data = try Data(contentsOf: fileURLPath)
                
                if let part = part, let parts = signature.parts, let part_size_in_bytes = signature.part_size_in_bytes {
                    data = partData(data: data, part: part, parts: parts, part_size_in_bytes: part_size_in_bytes)
                }
                
                let bodyData = self.createBody(parameters: videoDictionary, boundary: boundary, data: data, mimeType: "video/\(type)", filename: "video.\(type)")
                request.setValue(String(bodyData.count), forHTTPHeaderField: "Content-Length")
                request.httpBody = bodyData
                
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
                
                self.tryUploadTask(session: session, request: request, success: { (data, response) in
                    success(data, response)
                }) { (error) in
                    failure(error)
                }
                
            }catch let error{
                print("Data error : \(error)")
                failure(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Problem":"There was an issue with decoding the data"]))
            }
            
        }
        
    }
    
    private func tryUploadTask(session: URLSession,
                  request: NSMutableURLRequest,
                  success: @escaping (_ data: Data?, _ response: URLResponse?) -> Void,
                  failure: @escaping (_ error:Error?) -> Void){

        self.uploadTask = session.uploadTask(with: request as URLRequest, from: nil, completionHandler: { (data, response, error) in
            
            if error != nil {
                
                if error.debugDescription.contains("The network connection was lost."){
                    
                    //retry upload and remove the bytes sent in that part if multipart from the counter
                    self.bytes -= self.totalBytesSent
                    self.tryUploadTask(session: session, request: request, success: { (data, response) in
                        success(data, response)
                    }, failure: { (error) in
                        failure(error)
                    })
                }else{
                    failure(error)
                }
            }else{
                success(data, response)
            }
            
        })
        uploadTask.resume()
    }
    
    private func postParts(fileURLPath: URL,
                   signature: VzaarSignature,
                   multiPartVideoSignatureParameters: VzaarMultiPartVideoSignatureParameters,
                   success: @escaping () -> Void,
                   failure: @escaping (_ error:Error?) -> Void){
        
        if let filename = multiPartVideoSignatureParameters.filename, let parts = signature.parts{
            
            postPartRecursion(fileURLPath: fileURLPath, signature: signature, filename: filename, part: 0, parts: parts, success: {
                success()
                
            }, failure: { (error) in
                failure(error)
            })
            
        }
        
    }
    
    private func postPartRecursion(fileURLPath: URL,
                           signature: VzaarSignature,
                           filename: String,
                           part: Int,
                           parts: Int,
                           success: @escaping () -> Void,
                           failure: @escaping (_ error:Error?) -> Void){
        
        if part == parts {
            success()
        }else{
            
            postPart(fileURLPath: fileURLPath, signature: signature, part: part, filename: filename, success: { (data, response) in
                
                self.postPartRecursion(fileURLPath: fileURLPath, signature: signature, filename: filename, part: part+1, parts: parts, success: {
                    
                        success()
                    
                }, failure: { (error) in
                    failure(error)
                })
                
                
            }, failure: { (error) in
                failure(error)
            })
            
        }
        
        
        
    }
    
    private func partData(data: Data, part: Int, parts: Int, part_size_in_bytes: Int) -> Data{
        
        let count = data.count
        var dataParts = [Data]()
        
        if parts == 1{
            return data
        }
        
        for i in 0..<parts{
            
            let start = i * part_size_in_bytes
            var end = i * part_size_in_bytes + part_size_in_bytes
            if i == (parts-1) { end = count }
            let range = start..<end
            print(range)
            let subdata = data.subdata(in: range)
            dataParts.append(subdata)
            
        }
        
        print("current part:\(part)")
        
        return dataParts[part]
        
    }
    
    private func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
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
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Length: \(data.count)\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    

}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
        

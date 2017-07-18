    //
//  Vzaar.swift
//  Vzaar
//
//  Created by Andreas Bagias on 27/02/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public protocol VzaarUploadProgressDelegate {
    func vzaarUploadProgress(progress: Double)
}
    
public class Vzaar: NSObject, AWSUploadProgressDelegate{

    static var instance: Vzaar!
    
    public var config: VzaarConfig?
    
    var delegate: VzaarUploadProgressDelegate?
    var sessionDataTask:URLSessionDataTask!
    
    override init(){
        super.init()
    }
    
    func awsUploadProgress(progress: Double) {
        delegate?.vzaarUploadProgress(progress: progress)
    }
    
    public class func sharedInstance()-> Vzaar {
        self.instance = (self.instance ?? Vzaar())
        return self.instance
    }
    
    public func cancelUploadTask(){
        AWS.sharedInstance().cancelUploadTask()
        if sessionDataTask != nil{
            sessionDataTask.cancel()
        }
    }
    
    /**
     *  Function that gets one Video from vzaar
     *
     *  @param vzaarGetVideoParameters    The query parameters for the request headers
     *
     */
    public func getVideo(vzaarGetVideoParameters: VzaarGetVideoParameters,
                          success: @escaping (_ videos:VzaarVideo) -> Void,
                          failure: @escaping (_ error:VzaarError?) -> Void,
                          noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetVideoParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getVideo(withData: data, success: { (video) in
                    success(video)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets an array of Videos from vzaar
     *
     *  @param vzaarGetVideosParameters    The query parameters for the request headers
     *
     */
    public func getVideos(vzaarGetVideosParameters: VzaarGetVideosParameters,
                          success: @escaping (_ videos:[VzaarVideo]) -> Void,
                          failure: @escaping (_ error:VzaarError?) -> Void,
                          noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetVideosParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getVideos(withData: data, success: { (vzaarVideos) in
                    success(vzaarVideos)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that delete a Video from vzaar
     *
     *  @param vzaarDeleteVideoParameters    The query parameters for the delete request
     *
     */
    public func deleteVideo(vzaarDeleteVideoParameters: VzaarDeleteVideoParameters,
                         success: @escaping () -> Void,
                         failure: @escaping (_ error:VzaarError?) -> Void,
                         noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarDeleteVideoParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            success()
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that updates a Video from vzaar
     *
     *  @param vzaarUpdateVideoParameters    The query parameters for the update request
     *
     */
    public func updateVideo(vzaarUpdateVideoParameters: VzaarUpdateVideoParameters,
                            success: @escaping (_ videos:VzaarVideo) -> Void,
                            failure: @escaping (_ error:VzaarError?) -> Void,
                            noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarUpdateVideoParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getVideo(withData: data, success: { (video) in
                    success(video)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that uploads asynchronously a video by creating a single part signature then uploads the video to s3 and then creates the video from vzaar
     *
     *  @param singlePartVideoSignatureParameters    The body parameters for the single part signature
     *  @param uploadProgressDelegate                The delegate to get the progress of the video file upload
     *  @param fileURLPath                           The URL path to the video file to upload
     */
    public func uploadVideo(uploadProgressDelegate: VzaarUploadProgressDelegate?,
                            singlePartVideoSignatureParameters: VzaarSinglePartVideoSignatureParameters,
                            fileURLPath: URL,
                            success: @escaping (_ video:VzaarVideo?) -> Void,
                            failure: @escaping (_ error:VzaarError?) -> Void,
                            noResponse: @escaping (_ error:Error?) -> Void){
    
        delegate = uploadProgressDelegate
        
        createSignature(singlePartVideoSignatureParameters: singlePartVideoSignatureParameters, success: { (signature) in
            
            if let signature = signature{
                
                AWS.sharedInstance().delegate = self
                AWS.sharedInstance().postFile(fileURLPath: fileURLPath, signature: signature, singlePartVideoSignatureParameters: singlePartVideoSignatureParameters, success: { (data, response) in
                    
                    let videoCreationParameters = VzaarCreateVideoParameters(guid: signature.guid!)
                    if let filename = singlePartVideoSignatureParameters.filename{
                        videoCreationParameters.title = filename
                    }
                    
                    Vzaar.sharedInstance().createVideo(videoCreationParameters: videoCreationParameters, success: { (video) in
                        success(video)
                    }, failure: { (vzaarError) in
                        failure(vzaarError)
                    }, noResponse: { (error) in
                        noResponse(error)
                    })
                    
                }, failure: { (error) in
                    noResponse(error)
                })
            }else{
                noResponse(NSError(domain: "com.Vzaar.signature.error", code: 405, userInfo: ["Invalid Signature":"There was a problem with the signature response"]) as Error)
            }
            
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
        
    }
    
    /**
     *  Function that uploads asynchronously a video by creating a multi part signature then uploads the video to s3 in parts and then creates the video from vzaar
     *
     *  @param multiPartVideoSignatureParameters    The body parameters for the multi part signature
     *  @param uploadProgressDelegate                The delegate to get the progress of the video file upload
     *  @param fileURLPath                           The URL path to the video file to upload
     */
    public func uploadVideo(uploadProgressDelegate: VzaarUploadProgressDelegate?,
                            multiPartVideoSignatureParameters: VzaarMultiPartVideoSignatureParameters,
                            fileURLPath: URL,
                            success: @escaping (_ video:VzaarVideo?) -> Void,
                            failure: @escaping (_ error:VzaarError?) -> Void,
                            noResponse: @escaping (_ error:Error?) -> Void){
        
        delegate = uploadProgressDelegate
        
        createSignature(multiPartVideoSignatureParameters: multiPartVideoSignatureParameters, success: { (signature) in
            
            if let signature = signature{
                
                AWS.sharedInstance().delegate = self
                AWS.sharedInstance().postFile(fileURLPath: fileURLPath, signature: signature, multiPartVideoSignatureParameters: multiPartVideoSignatureParameters, success: {
                    
                    let videoCreationParameters = VzaarCreateVideoParameters(guid: signature.guid!)
                    if let filename = multiPartVideoSignatureParameters.filename{
                        videoCreationParameters.title = filename
                    }
                    
                    Vzaar.sharedInstance().createVideo(videoCreationParameters: videoCreationParameters, success: { (video) in
                        success(video)
                    }, failure: { (vzaarError) in
                        failure(vzaarError)
                    }, noResponse: { (error) in
                        noResponse(error)
                    })
                    
                }, failure: { (error) in
                    noResponse(error)
                })
            }else{
                noResponse(NSError(domain: "com.Vzaar.signature.error", code: 405, userInfo: ["Invalid Signature":"There was a problem with the signature response"]) as Error)
            }
            
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
        
    }
    
    /**
     *  Function that creates asynchronously a signature that is required for a multi-part file upload
     *  The size of your file MUST be at least 5MB
     *
     *  @param multiPartVideoSignatureParameters    The body parameters for the multi part signature
     */
    public func createSignature(multiPartVideoSignatureParameters: VzaarMultiPartVideoSignatureParameters,
                                success: @escaping (_ signature:VzaarSignature?) -> Void,
                                failure: @escaping (_ error:VzaarError?) -> Void,
                                noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = multiPartVideoSignatureParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                if let signature = VzaarParser.getSignature(withData: data){
                    success(signature)
                }else{
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json":"There was a problem with json serialization"]) as Error)
                }
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
        
    }
    
    /**
     *  Function that creates asynchronously a signature that is required for a single-part file upload
     *  The maximum allowed file size for this signature is 5GB
     *
     *  @param singlePartVideoSignatureParameters   The body parameters for the single part signature
     */
    public func createSignature(singlePartVideoSignatureParameters: VzaarSinglePartVideoSignatureParameters,
                                success: @escaping (_ signature:VzaarSignature?) -> Void,
                                failure: @escaping (_ error:VzaarError?) -> Void,
                                noResponse: @escaping (_ error:Error?) -> Void){
    
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = singlePartVideoSignatureParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                if let signature = VzaarParser.getSignature(withData: data){
                    success(signature)
                }else{
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json":"There was a problem with json serialization"]) as Error)
                }
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Invalid Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that creates asynchronously a video
     *
     *  @param videoCreationParameters              The body parameters for the video creation
     */
    public func createVideo(videoCreationParameters: VzaarCreateVideoParameters,
                            success: @escaping (_ video:VzaarVideo?) -> Void,
                            failure: @escaping (_ error:VzaarError?) -> Void,
                            noResponse: @escaping (_ error:Error?) -> Void){
    
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = videoCreationParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getVideo(withData: data, success: { (video) in
                    success(video)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json":message]) as Error)
                })
            }else{
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Invalid Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
        
    }
    
    /**
     *  Function that gets an array of Categories from vzaar
     *
     *  Listing categories will page through all your categories, returning every category you have created regardless 
     *  of the parent category or category depth i.e. this allows you to retrieve your entire collection of categories through paged results.
     *
     *  @param vzaarGetCategoriesParameters    The query parameters for the request headers
     *
     */
    public func getCategories(vzaarGetCategoriesParameters: VzaarGetCategoriesParameters,
                          success: @escaping (_ categories:[VzaarCategory]) -> Void,
                          failure: @escaping (_ error:VzaarError?) -> Void,
                          noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetCategoriesParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getCategories(withData: data, success: { (vzaarCategories) in
                    success(vzaarCategories)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that creates a Category from vzaar
     *
     *  @param vzaarCreateCategoryParameters    The query parameters for the request headers
     *
     */
    public func createCategory(vzaarCreateCategoryParameters: VzaarCreateCategoryParameters,
                              success: @escaping (_ category:VzaarCategory) -> Void,
                              failure: @escaping (_ error:VzaarError?) -> Void,
                              noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarCreateCategoryParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getCategory(withData: data, success: { (vzaarCategory) in
                    success(vzaarCategory)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that updates a Category from vzaar
     *
     *  @param vzaarUpdateCategoryParameters    The query parameters for the request headers
     *
     */
    public func updateCategory(vzaarUpdateCategoryParameters: VzaarUpdateCategoryParameters,
                               success: @escaping (_ category:VzaarCategory) -> Void,
                               failure: @escaping (_ error:VzaarError?) -> Void,
                               noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarUpdateCategoryParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getCategory(withData: data, success: { (vzaarCategory) in
                    success(vzaarCategory)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that delete a Video from vzaar
     *
     *  Deleting a category will also delete any children
     *
     *  @param vzaarDeleteCategoryParameters    The query parameters for the delete request
     *
     */
    public func deleteCategory(vzaarDeleteCategoryParameters: VzaarDeleteCategoryParameters,
                            success: @escaping () -> Void,
                            failure: @escaping (_ error:VzaarError?) -> Void,
                            noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarDeleteCategoryParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            success()
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets one Category from vzaar
     *
     *  @param vzaarGetCategoryParameters    The query parameters for the request headers
     *
     */
    public func getCategory(vzaarGetCategoryParameters: VzaarGetCategoryParameters,
                         success: @escaping (_ category:VzaarCategory) -> Void,
                         failure: @escaping (_ error:VzaarError?) -> Void,
                         noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetCategoryParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getCategory(withData: data, success: { (category) in
                    success(category)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets an array of Categories Subtree from vzaar
     *
     *  Listing a category's subtree will always include the category itself, plus any descendants that may exist.
     *
     *  @param vzaarGetCategoriesSubtreeParameters    The query parameters for the request headers
     *
     */
    public func getCategoriesSubtree(vzaarGetCategoriesSubtreeParameters: VzaarGetCategoriesSubtreeParameters,
                              success: @escaping (_ categories:[VzaarCategory]) -> Void,
                              failure: @escaping (_ error:VzaarError?) -> Void,
                              noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetCategoriesSubtreeParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getCategories(withData: data, success: { (vzaarCategories) in
                    success(vzaarCategories)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets one Ingest Recipe from vzaar
     *
     *  @param vzaarGetIngestRecipeParameters    The query parameters for the request headers
     *
     */
    public func getIngestRecipe(vzaarGetIngestRecipeParameters: VzaarGetIngestRecipeParameters,
                            success: @escaping (_ ingestRecipe:VzaarIngestRecipe) -> Void,
                            failure: @escaping (_ error:VzaarError?) -> Void,
                            noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetIngestRecipeParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getIngestRecipe(withData: data, success: { (ingestRecipe) in
                    success(ingestRecipe)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets an array of Ingest Recipes from vzaar
     *
     *  @param vzaarGetIngestRecipesParameters    The query parameters for the request headers
     *
     */
    public func getIngestRecipes(vzaarGetIngestRecipesParameters: VzaarGetIngestRecipesParameters,
                              success: @escaping (_ ingestRecipes:[VzaarIngestRecipe]) -> Void,
                              failure: @escaping (_ error:VzaarError?) -> Void,
                              noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetIngestRecipesParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getIngestRecipes(withData: data, success: { (vzaarIngestRecipes) in
                    success(vzaarIngestRecipes)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that creates an Ingest Recipe from vzaar
     *
     *  @param vzaarCreateIngestRecipeParameters    The query parameters for the request headers
     *
     */
    public func createIngestRecipe(vzaarCreateIngestRecipeParameters: VzaarCreateIngestRecipeParameters,
                               success: @escaping (_ ingestRecipe:VzaarIngestRecipe) -> Void,
                               failure: @escaping (_ error:VzaarError?) -> Void,
                               noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarCreateIngestRecipeParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getIngestRecipe(withData: data, success: { (vzaarIngestRecipe) in
                    success(vzaarIngestRecipe)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that updates an Ingest Recipe from vzaar
     *
     *  @param vzaarUpdateIngestRecipeParameters    The query parameters for the request headers
     *
     */
    public func updateIngestRecipe(vzaarUpdateIngestRecipeParameters: VzaarUpdateIngestRecipeParameters,
                                   success: @escaping (_ ingestRecipe:VzaarIngestRecipe) -> Void,
                                   failure: @escaping (_ error:VzaarError?) -> Void,
                                   noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarUpdateIngestRecipeParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getIngestRecipe(withData: data, success: { (vzaarIngestRecipe) in
                    success(vzaarIngestRecipe)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that deletes an Ingest Recipe from vzaar
     *
     *  If you try to delete your default ingest recipe you will receive an error response. 
     *  In this case you will first need to update another ingest recipe as your new default, and then proceed to delete the original ingest recipe.
     *
     *  @param vzaarDeleteIngestRecipeParameters    The query parameters for the delete request
     *
     */
    public func deleteIngestRecipe(vzaarDeleteIngestRecipeParameters: VzaarDeleteIngestRecipeParameters,
                               success: @escaping () -> Void,
                               failure: @escaping (_ error:VzaarError?) -> Void,
                               noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarDeleteIngestRecipeParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            success()
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets an array of Encoding Presets from vzaar
     *
     *  @param vzaarGetEncodingPresetsParameters    The query parameters for the request headers
     *
     */
    public func getEncodingPresets(vzaarGetEncodingPresetsParameters: VzaarGetEncodingPresetsParameters,
                                 success: @escaping (_ encodingPresets:[VzaarEncodingPreset]) -> Void,
                                 failure: @escaping (_ error:VzaarError?) -> Void,
                                 noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetEncodingPresetsParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getEncodingPresets(withData: data, success: { (vzaarEncodingPresets) in
                    success(vzaarEncodingPresets)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets an Encoding Preset from vzaar
     *
     *  @param vzaarGetEncodingPresetParameters    The query parameters for the request headers
     *
     */
    public func getEncodingPreset(vzaarGetEncodingPresetParameters: VzaarGetEncodingPresetParameters,
                                   success: @escaping (_ encodingPreset:VzaarEncodingPreset) -> Void,
                                   failure: @escaping (_ error:VzaarError?) -> Void,
                                   noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetEncodingPresetParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getEncodingPreset(withData: data, success: { (vzaarEncodingPreset) in
                    success(vzaarEncodingPreset)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets an array of Playlists from vzaar
     *
     *  @param vzaarGetPlaylistsParameters    The query parameters for the request headers
     *
     */
    public func getPlaylists(vzaarGetPlaylistsParameters: VzaarGetPlaylistsParameters,
                                   success: @escaping (_ playlists:[VzaarPlaylist]) -> Void,
                                   failure: @escaping (_ error:VzaarError?) -> Void,
                                   noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetPlaylistsParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getPlaylists(withData: data, success: { (vzaarPlaylists) in
                    success(vzaarPlaylists)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that gets a Playlist from vzaar
     *
     *  @param vzaarGetPlaylistParameters    The query parameters for the request headers
     *
     */
    public func getPlaylist(vzaarGetPlaylistParameters: VzaarGetPlaylistParameters,
                             success: @escaping (_ playlist:VzaarPlaylist) -> Void,
                             failure: @escaping (_ error:VzaarError?) -> Void,
                             noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarGetPlaylistParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getPlaylist(withData: data, success: { (vzaarPlaylist) in
                    success(vzaarPlaylist)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that creates a link upload from vzaar
     *
     *  @param vzaarCreateLinkUploadParameters    The query parameters for the request headers
     *
     */
    public func createLinkUpload(vzaarCreateLinkUploadParameters: VzaarCreateLinkUploadParameters,
                            success: @escaping (_ video:VzaarVideo) -> Void,
                            failure: @escaping (_ error:VzaarError?) -> Void,
                            noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarCreateLinkUploadParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getVideo(withData: data, success: { (vzaarVideo) in
                    success(vzaarVideo)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that creates an Playlist from vzaar
     *
     *  @param vzaarCreatePlaylistParameters    The query parameters for the request headers
     *
     */
    public func createPlaylist(vzaarCreatePlaylistParameters: VzaarCreatePlaylistParameters,
                                   success: @escaping (_ playlist:VzaarPlaylist) -> Void,
                                   failure: @escaping (_ error:VzaarError?) -> Void,
                                   noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarCreatePlaylistParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getPlaylist(withData: data, success: { (vzaarPlaylist) in
                    success(vzaarPlaylist)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that updates an Playlist from vzaar
     *
     *  @param vzaarUpdatePlaylistParameters    The query parameters for the request headers
     *
     */
    public func updatePlaylist(vzaarUpdatePlaylistParameters: VzaarUpdatePlaylistParameters,
                               success: @escaping (_ playlist:VzaarPlaylist) -> Void,
                               failure: @escaping (_ error:VzaarError?) -> Void,
                               noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarUpdatePlaylistParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            if let data = data{
                VzaarParser.getPlaylist(withData: data, success: { (vzaarPlaylist) in
                    success(vzaarPlaylist)
                }, failure: { (message) in
                    noResponse(NSError(domain: "com.Vzaar.json.error", code: 405, userInfo: ["Invalid Json": message]) as Error)
                })
            }else {
                noResponse(NSError(domain: "com.Vzaar.data.error", code: 405, userInfo: ["Data":"There was a problem with data"]) as Error)
            }
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    /**
     *  Function that deletes a Playlist from vzaar
     *
     *  @param vzaarDeletePlaylistParameters    The query parameters for the delete request
     *
     */
    public func deletePlaylist(vzaarDeletePlaylistParameters: VzaarDeletePlaylistParameters,
                                   success: @escaping () -> Void,
                                   failure: @escaping (_ error:VzaarError?) -> Void,
                                   noResponse: @escaping (_ error:Error?) -> Void){
        
        guard let config = self.config else {
            noResponse(NSError(domain: "com.Vzaar.RequestParameters.error", code: 405, userInfo: ["Request Parameters":"You need to set Vzaar Config Parameters"]) as Error)
            return
        }
        
        let request = vzaarDeletePlaylistParameters.createRequest(withConfig: config)
        
        performSessionDataTask(withRequest: request, success: { (data, response) in
            success()
        }, failure: { (vzaarError) in
            failure(vzaarError)
        }) { (error) in
            noResponse(error)
        }
    }
    
    func performSessionDataTask(withRequest request:NSMutableURLRequest,
                                success: @escaping (_ data:Data?, _ response:URLResponse?) -> Void,
                                failure: @escaping (_ error:VzaarError?) -> Void,
                                noResponse: @escaping (_ error:Error?) -> Void){
    
        sessionDataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                    if let dataDict = VzaarParser.getDictionary(data: data){
                        let vzaarError = VzaarError(withDataDictionary: dataDict, statusCode: httpResponse.statusCode as NSNumber/*objective-C*/)
                        failure(vzaarError)
                    }
                }else{
                    success(data, response)
                }
            }else {
                noResponse(error)
            }
        }
        sessionDataTask?.resume()
    }
    
    
    
}

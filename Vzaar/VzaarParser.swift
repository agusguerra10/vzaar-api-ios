//
//  VzaarParser.swift
//  Vzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

class VzaarParser: NSObject {

    // Dictionary data parser
    static func getDictionary(data: Data?) -> NSDictionary?{
        if data == nil { return nil }
        if data?.count == 0 { return nil }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data! , options: .mutableContainers) as? [String: Any] {
                return json as NSDictionary?
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // Signature data parser
    static func getSignature(withData data: Data) -> VzaarSignature?{
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                return VzaarSignature(withDictionary: json["data"] as! NSDictionary)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // Video data parser
    static func getVideo(withData data: Data, success: @escaping (_ video:VzaarVideo) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                let video: VzaarVideo = VzaarVideo(withDict: json["data"] as! NSDictionary)
                success(video)
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Videos data parser
    static func getVideos(withData data: Data, success: @escaping (_ videos:[VzaarVideo]) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                
                if let videosArrayDict = json["data"] as? [NSDictionary]{
                    var videos: [VzaarVideo] = [VzaarVideo]()
                    for videoDict in videosArrayDict{
                        videos.append(VzaarVideo(withDict: videoDict))
                    }
                    success(videos)
                }
                
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Categories data parser
    static func getCategories(withData data: Data, success: @escaping (_ categories:[VzaarCategory]) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                
                if let categoriesArrayDict = json["data"] as? [NSDictionary]{
                    var categories: [VzaarCategory] = [VzaarCategory]()
                    for categoryDict in categoriesArrayDict{
                        categories.append(VzaarCategory(withDictionary: categoryDict))
                    }
                    success(categories)
                }
                
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Category data parser
    static func getCategory(withData data: Data, success: @escaping (_ category:VzaarCategory) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                let category: VzaarCategory = VzaarCategory(withDictionary: json["data"] as! NSDictionary)
                success(category)
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Ingest Recipes data parser
    static func getIngestRecipes(withData data: Data, success: @escaping (_ ingestRecipes:[VzaarIngestRecipe]) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                
                if let ingestRecipesArrayDict = json["data"] as? [NSDictionary]{
                    var ingestRecipes: [VzaarIngestRecipe] = [VzaarIngestRecipe]()
                    for ingestRecipeDict in ingestRecipesArrayDict{
                        ingestRecipes.append(VzaarIngestRecipe(withDict: ingestRecipeDict))
                    }
                    success(ingestRecipes)
                }
                
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Ingest Recipe data parser
    static func getIngestRecipe(withData data: Data, success: @escaping (_ ingestRecipe:VzaarIngestRecipe) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                let ingestRecipe: VzaarIngestRecipe = VzaarIngestRecipe(withDict: json["data"] as! NSDictionary)
                success(ingestRecipe)
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Encoding Presets data parser
    static func getEncodingPresets(withData data: Data, success: @escaping (_ encodingPresets:[VzaarEncodingPreset]) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                
                if let encodingPresetsArrayDict = json["data"] as? [NSDictionary]{
                    var encodingPresets: [VzaarEncodingPreset] = [VzaarEncodingPreset]()
                    for encodingPresetDict in encodingPresetsArrayDict{
                        encodingPresets.append(VzaarEncodingPreset(withDict: encodingPresetDict))
                    }
                    success(encodingPresets)
                }
                
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Encoding Preset data parser
    static func getEncodingPreset(withData data: Data, success: @escaping (_ encodingPreset:VzaarEncodingPreset) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                let encodingPreset: VzaarEncodingPreset = VzaarEncodingPreset(withDict: json["data"] as! NSDictionary)
                success(encodingPreset)
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Playlists data parser
    static func getPlaylists(withData data: Data, success: @escaping (_ playlists:[VzaarPlaylist]) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                
                if let playlistsArrayDict = json["data"] as? [NSDictionary]{
                    var playlists: [VzaarPlaylist] = [VzaarPlaylist]()
                    for playlistDict in playlistsArrayDict{
                        playlists.append(VzaarPlaylist(withDict: playlistDict))
                    }
                    success(playlists)
                }
                
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
    
    // Playlist data parser
    static func getPlaylist(withData data: Data, success: @escaping (_ playlist:VzaarPlaylist) -> Void, failure: @escaping (_ message: String) -> Void){
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                let playlist: VzaarPlaylist = VzaarPlaylist(withDict: json["data"] as! NSDictionary)
                success(playlist)
            }
        } catch let error{
            failure(error.localizedDescription)
        }
    }
}

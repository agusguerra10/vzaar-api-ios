//
//  VzaarCreateIngestRecipeParameters.swift
//  Vzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarCreateIngestRecipeParameters: VzaarRequestParameters {
    
    //Name for the recipe - REQUIRED
    public var name: String?
    //List of encoding preset id values to associate with this recipe - REQUIRED
    public var encoding_preset_ids: [NSNumber]?/* Objective-c compatible */
    //Recipe description.
    public var ingestRecipeDescription: String?
    //Flag this recipe as my default recipe. You can only have one default recipe.
    public var defaut: NSNumber?/* Objective-c compatible */
    //Perform multipass encoding (this will slow down your video processing but yield better quality results).
    public var multipass: NSNumber?/* Objective-c compatible */
    //Generate an animated gif thumbnail.
    public var generate_animated_thumb: NSNumber?/* Objective-c compatible */
    //Generate sprites (used for scrubbing thumbnails in the vzaar player).
    public var generate_sprite: NSNumber?/* Objective-c compatible */
    //Burn your watermark into the transcoded video (requires additional watermark setup).
    public var use_watermark: NSNumber?/* Objective-c compatible */
    //Send your video to your associated YouTube account (requires YouTube syndication access and additional setup).
    public var send_to_youtube: NSNumber?/* Objective-c compatible */
    //Send email notification after video processing
    public var notify_by_email: NSNumber?/* Objective-c compatible */
    //Send http pingback after video processing.
    public var notify_by_pingback: NSNumber?/* Objective-c compatible */
    
    override init() {
        super.init()
    }
    
    public convenience init(name: String, encoding_preset_ids: [NSNumber]){
        self.init()
        
        self.name = name
        self.encoding_preset_ids = encoding_preset_ids
        super.method = MethodType.post
        super.urlSuffix = "ingest_recipes"
    }
    
    func createBodyParameters(){
        var params: [String: Any] = [String: Any]()
        
        if let name = name{ params["name"] = name }
        if let encoding_preset_ids = encoding_preset_ids{ params["encoding_preset_ids"] = encoding_preset_ids }
        if let ingestRecipeDescription = ingestRecipeDescription{ params["description"] = ingestRecipeDescription }
        if let defaut = defaut{ params["defaut"] = defaut }
        if let multipass = multipass{ params["multipass"] = multipass }
        if let generate_animated_thumb = generate_animated_thumb{ params["generate_animated_thumb"] = generate_animated_thumb }
        if let generate_sprite = generate_sprite{ params["generate_sprite"] = generate_sprite }
        if let use_watermark = use_watermark{ params["use_watermark"] = use_watermark }
        if let send_to_youtube = send_to_youtube{ params["send_to_youtube"] = send_to_youtube }
        if let notify_by_pingback = notify_by_pingback{ params["notify_by_pingback"] = notify_by_pingback }
        
        bodyParameters = params
    }
    
    override func createRequest(withConfig config: VzaarConfig) -> NSMutableURLRequest {
        createBodyParameters()
        return super.createRequest(withConfig: config)
    }
    
}

//
//  VzaarIngestRecipe.swift
//  Vzaar
//
//  Created by Andreas Bagias on 06/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarIngestRecipe: NSObject{

    public var id: NSNumber?/*objective-C*/
    public var name: String?
    public var recipe_type: String?
    public var ingestRecipeDescription: String?
    public var account_id: NSNumber?/*objective-C*/
    public var user_id: NSNumber?/*objective-C*/
    public var _default: NSNumber?/*objective-C*/
    public var multipass: NSNumber?/*objective-C*/
    public var frame_grab_time: String?
    public var generate_animated_thumb: NSNumber?/*objective-C*/
    public var generate_sprite: NSNumber?/*objective-C*/
    public var use_watermark: NSNumber?/*objective-C*/
    public var send_to_youtube: NSNumber?/*objective-C*/
    public var notify_by_email: NSNumber?/*objective-C*/
    public var notify_by_pingback: NSNumber?/*objective-C*/
    public var created_at: String?
    public var updated_at: String?
    public var encoding_presets: [VzaarEncodingPreset]?
    
    public init(withDict dict: NSDictionary){
        
        if let id = dict["id"] as? NSNumber/*objective-C*/{
            self.id = id
        }
        if let name = dict["name"] as? String{
            self.name = name
        }
        if let recipe_type = dict["recipe_type"] as? String{
            self.recipe_type = recipe_type
        }
        if let ingestRecipeDescription = dict["description"] as? String{
            self.ingestRecipeDescription = ingestRecipeDescription
        }
        if let account_id = dict["account_id"] as? NSNumber/*objective-C*/{
            self.account_id = account_id
        }
        if let user_id = dict["user_id"] as? NSNumber/*objective-C*/{
            self.user_id = user_id
        }
        if let _default = dict["default"] as? NSNumber/*objective-C*/{
            self._default = _default
        }
        if let multipass = dict["multipass"] as? NSNumber/*objective-C*/{
            self.multipass = multipass
        }
        if let frame_grab_time = dict["frame_grab_time"] as? String{
            self.frame_grab_time = frame_grab_time
        }
        if let generate_animated_thumb = dict["generate_animated_thumb"] as? NSNumber/*objective-C*/{
            self.generate_animated_thumb = generate_animated_thumb
        }
        if let generate_sprite = dict["generate_sprite"] as? NSNumber/*objective-C*/{
            self.generate_sprite = generate_sprite
        }
        if let use_watermark = dict["use_watermark"] as? NSNumber/*objective-C*/{
            self.use_watermark = use_watermark
        }
        if let send_to_youtube = dict["send_to_youtube"] as? NSNumber/*objective-C*/{
            self.send_to_youtube = send_to_youtube
        }
        if let notify_by_email = dict["notify_by_email"] as? NSNumber/*objective-C*/{
            self.notify_by_email = notify_by_email
        }
        if let notify_by_pingback = dict["notify_by_pingback"] as? NSNumber/*objective-C*/{
            self.notify_by_pingback = notify_by_pingback
        }
        if let created_at = dict["created_at"] as? String{
            self.created_at = created_at
        }
        if let updated_at = dict["updated_at"] as? String{
            self.updated_at = updated_at
        }
        if let encoding_presets = dict["encoding_presets"] as? [NSDictionary]{
            self.encoding_presets = [VzaarEncodingPreset]()
            for encoding_presetDict in encoding_presets{
                let encoding_preset = VzaarEncodingPreset(withDict: encoding_presetDict)
                self.encoding_presets?.append(encoding_preset)
            }
        }
        
    }
    
}







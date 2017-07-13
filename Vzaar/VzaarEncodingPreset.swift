//
//  VzaarEncodingPreset.swift
//  Vzaar
//
//  Created by Andreas Bagias on 06/03/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation

public class VzaarEncodingPreset: NSObject{
    
    public var id: Int?
    public var name: String?
    public var encodingPresetDescription: String?
    public var output_format: String?
    public var bitrate_kbps: Int?
    public var max_bitrate_kbps: Int?
    public var long_dimension: Int?
    public var video_codec: String?
    public var profile: String?
    public var frame_rate_upper_threshold: String?
    public var audio_bitrate_kbps: Int?
    public var audio_channels: Int?
    public var audio_sample_rate: Int?
    public var created_at: String?
    public var updated_at: String?
    
    public init(withDict dict: NSDictionary){
        
        if let id = dict["id"] as? Int{
            self.id = id
        }
        if let name = dict["name"] as? String{
            self.name = name
        }
        if let encodingPresetDescription = dict["description"] as? String{
            self.encodingPresetDescription = encodingPresetDescription
        }
        if let output_format = dict["output_format"] as? String{
            self.output_format = output_format
        }
        if let bitrate_kbps = dict["bitrate_kbps"] as? Int{
            self.bitrate_kbps = bitrate_kbps
        }
        if let max_bitrate_kbps = dict["max_bitrate_kbps"] as? Int{
            self.max_bitrate_kbps = max_bitrate_kbps
        }
        if let long_dimension = dict["long_dimension"] as? Int{
            self.long_dimension = long_dimension
        }
        if let video_codec = dict["video_codec"] as? String{
            self.video_codec = video_codec
        }
        if let profile = dict["profile"] as? String{
            self.profile = profile
        }
        if let frame_rate_upper_threshold = dict["frame_rate_upper_threshold"] as? String{
            self.frame_rate_upper_threshold = frame_rate_upper_threshold
        }
        if let audio_bitrate_kbps = dict["audio_bitrate_kbps"] as? Int{
            self.audio_bitrate_kbps = audio_bitrate_kbps
        }
        if let audio_channels = dict["audio_channels"] as? Int{
            self.audio_channels = audio_channels
        }
        if let audio_sample_rate = dict["audio_sample_rate"] as? Int{
            self.audio_sample_rate = audio_sample_rate
        }
        if let created_at = dict["created_at"] as? String{
            self.created_at = created_at
        }
        if let updated_at = dict["updated_at"] as? String{
            self.updated_at = updated_at
        }
        
    }
    
}

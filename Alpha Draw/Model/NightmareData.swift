//
//  NightmareData.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import Foundation

struct NightmareData: Decodable {
    var completed_at: String?
    var created_at: String?
    var error: String?
    var hardware: String?
    var id: String?
    var input: NightmareInput?
    var logs: String?
    var metrics: Metrics?
    var output: [String]?
    var urls: Option?
    var version: String?
}

struct NightmareBodyReuqest: Decodable {
    var version: String?
    var input: NightmareInput?
}

struct NightmareInput: Decodable {
    var prompt: String?
    var step: String?
    var width: String?
    var height: String?
    var diffusion_model: String?
    var diffusion_sampling_mode: String?
    var ViTB32: Bool?
    var ViTB16: Bool?
    var RN50: Bool?
    var use_secondary_model: Bool?
    var clip_guidance_scale: String?
    var range_scale: String?
    var cutn_batches: String?
    var init_scale: String?
    var target_scale: String?
    var skip_steps: String?
    var display_rate: String?
    var guidance_scale: String?
    var num_inference_steps: String?
}

//
//  StableDiffusionData.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/31/22.
//

import UIKit

struct StableDiffusionData: Decodable {
    var completed_at: String?
    var created_at: String?
    var error: String?
    var hardware: String?
    var id: String?
    var input: StableDiffusionInput?
    var logs: String?
    var metrics: Metrics?
    var output: [String]?
    var started_at: String?
    var status: String?
    var urls: Option?
    var version: String?
}

struct StableDiffusionInput: Decodable {
    var prompt: String?
    var width: String?
    var height: String?
    var guidance_scale: String?
    var num_inference_steps: String?
    var prompt_strength: String?
    var num_outputs: String?
}

struct StableDiffusionBodyReuqest: Decodable {
    var version: String?
    var input: StableDiffusionInput?
}

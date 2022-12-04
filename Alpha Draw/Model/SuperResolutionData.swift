//
//  SuperResolution.swift
//  Alpha Draw
//
//  Created by Misaki.999 on 12/2/22.
//

import Foundation

struct SuperResolutionData: Decodable {
    var completed_at: String?
    var created_at: String?
    var error: String?
    var hardware: String?
    var id: String?
    var input: superResInput?
    var logs: String?
    var metrics: Metrics?
    var output_files: [String]?
    var output: String?
    var urls: Option?
    var version: String?
    var status: String?
}

struct SuperResolutionReuqest: Decodable {
    var version: String?
    var input: superResInput?
}

struct superResInput: Decodable {
    var task_type: String?
    var img_url: String?
    var noise: String?
    var jpeg: String?
    var version: String?
    var scale: String?
}

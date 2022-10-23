//
//  PixrayData.swift
//  https://dazhizhong.gitbook.io/pixray-docs/docs/primary-settings
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import Foundation

struct PixrayData: Decodable {
    var completed_at: String?
    var created_at: String?
    var error: String?
    var hardware: String?
    var id: String?
    var input: PixrayInput?
    var logs: String?
    var metrics: Metrics?
    var output: [String]?
    var urls: Option?
    var version: String?
}

struct PixrayBodyReuqest: Decodable {
    var version: String?
    var input: PixrayInput?
}

struct PixrayInput: Decodable {
    var prompts: String?
    var drawer: String?
    // var settings: String?
}


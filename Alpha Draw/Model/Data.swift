//
//  Data.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import Foundation

// Common data used:

struct Metrics: Decodable {
    var perdict_time: Int?
}

struct Option: Decodable {
    var get: String?
    var cancel: String?
}

//
//  Pokemon.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import Foundation

struct PokemonData: Decodable {
    var completed_at: String?
    var created_at: String?
    var error: String?
    var hardware: String?
    var id: String?
    var input: InputParameter?
    var logs: String?
    var metrics: Metrics?
    var output: [String]?
    var urls: Option?
    var version: String?
}

struct PokemonBodyReuqest: Decodable{
    var version: String
    var input: InputParameter
}

struct InputParameter: Decodable {
    var prompt: String?
    var num_outputs: String?
    var num_inference_steps: String?
    var guidance_sclae: String?
    var seed: String?
}

struct Metrics: Decodable {
    var perdict_time: Int?
}

struct Option: Decodable {
    var get: String?
    var cancel: String?
}

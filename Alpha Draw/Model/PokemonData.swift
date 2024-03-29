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
    var input: PokemonInput?
    var logs: String?
    var metrics: Metrics?
    var output: [String]?
    var urls: Option?
    var version: String?
}

struct PokemonBodyReuqest: Decodable{
    var version: String?
    var input: PokemonInput?
}

struct PokemonInput: Decodable {
    var prompt: String?
    var num_outputs: String?
    var num_inference_steps: String?
    var guidance_sclae: String?
    var seed: String?
}



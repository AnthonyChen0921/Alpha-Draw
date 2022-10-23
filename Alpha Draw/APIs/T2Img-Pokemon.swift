//
//  Text2Img-Pokemon.swift
//  Generate Pokémon from a text description
//  url: https://replicate.com/lambdal/text-to-pokemon
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import Foundation


/**
 *  @brief: This function is used to generate a Pokemon from a text description
 *  @param: completion: The completion handler
 *  @param: bodyRequest: The body request of the API, written in Swift Struct, see PokemonData.swift for more details
 *  @return: Void
 */
func fetchPokemonInitialRequest(completion: @escaping (PokemonData) -> Void, bodyRequest: PokemonBodyReuqest) {
    let url = URL(string: "https://api.replicate.com/v1/predictions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Token c3a4bed5dc02edbba4d02d9f4b4f91e1011f9b5b", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = convertBodyRequestToStringArray(bodyRequest: bodyRequest)
    request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
            return
        }
        do {
            let pokemon = try JSONDecoder().decode(PokemonData.self, from: data)
            completion(pokemon)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

/**
 *  @brief: This function is used to request an update of the Pokemon image
 *  @param: completion: The completion handler
 *  @param: predictionId: The prediction id of the API, will be returned by the initial request (InitalRequest also contains a get request url)
 *  @return: Void
 */
func fetchPokemonByPredictionId(completion: @escaping (PokemonData) -> Void, predictionId: String) {
    let url = URL(string: "https://api.replicate.com/v1/predictions/\(predictionId)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Token c3a4bed5dc02edbba4d02d9f4b4f91e1011f9b5b", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
            return
        }
        do {
            let pokemon = try JSONDecoder().decode(PokemonData.self, from: data)
            completion(pokemon)
        } catch {
            print("Error decoding response: \(error)")
        }
    }.resume()
}

/**
 *  @brief: This function is used to convert the body request of the API, written in Swift Struct, to a String Array
 *  @param: bodyRequest: The body request of the API, written in Swift Struct, see Pokemon.swift for more details
 *  @return: [String: Any]
 */
func convertBodyRequestToStringArray(bodyRequest: PokemonBodyReuqest) -> [String : Any]{
    let body = [
        "version": bodyRequest.version!,
        "input": [
            "prompt": bodyRequest.input?.prompt!,
            "num_inference_steps": bodyRequest.input?.num_inference_steps!,
            "guidance_scale": bodyRequest.input?.guidance_sclae!,
            "num_outputs": bodyRequest.input?.num_outputs!
        ]
    ] as [String : Any]
    return body
}



//  Mark: - Useful information About Pokemon API

/**
    Web API for Text2Img-Pokemon

      const response = await fetch("https://api.replicate.com/v1/predictions", {
        method: "POST",
        headers: {
          Authorization: "Token c3a4bed5dc02edbba4d02d9f4b4f91e1011f9b5b",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          version:
            "3554d9e699e09693d3fa334a79c58be9a405dd021d3e11281256d53185868912",
          input: {
            prompt: req.body.prompt,
            num_inference_steps: req.body.step,
            guidance_scale: "7",
            num_outputs: "4",
          },
        }),
      });
*/


/**
    Example of bodyRequest Object:
    let body = [
        "version": "3554d9e699e09693d3fa334a79c58be9a405dd021d3e11281256d53185868912",
        "input": [
            "prompt": "A small, blue, flying Pokémon with a long tail.",
            "num_inference_steps": "10",
            "guidance_scale": "7",
            "num_outputs": "1"
        ]
    ] as [String : Any]
*/


